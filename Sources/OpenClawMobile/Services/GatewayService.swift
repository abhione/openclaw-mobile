import Foundation

// MARK: - Gateway Service (WebSocket-based)
// OpenClaw Gateway uses WebSocket, not REST.
// Protocol: connect with auth params, then send/receive JSON-RPC style messages.

@MainActor
final class GatewayService: ObservableObject {
    private let config: AppConfiguration
    private var webSocket: URLSessionWebSocketTask?
    private var urlSession: URLSession?

    @Published var messages: [ChatMessage] = []
    @Published var isConnected: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var agentName: String = ""

    init(config: AppConfiguration) {
        self.config = config
    }

    // MARK: - Connection

    func connect() {
        guard config.isConfigured else {
            error = "Gateway not configured"
            return
        }

        disconnect()

        // Build WebSocket URL with auth params
        // OpenClaw WS auth: connect.params.auth.token or connect.params.auth.password
        var urlString = config.gatewayURL
            .replacingOccurrences(of: "http://", with: "ws://")
            .replacingOccurrences(of: "https://", with: "wss://")

        if !urlString.hasPrefix("ws://") && !urlString.hasPrefix("wss://") {
            urlString = "ws://\(urlString)"
        }

        // Socket.IO style connection — OpenClaw uses socket.io under the hood
        // The Control UI connects via socket.io with auth in handshake
        // For a native client, we use the socket.io transport protocol
        urlString += "/socket.io/?EIO=4&transport=websocket"

        guard let url = URL(string: urlString) else {
            error = "Invalid gateway URL"
            return
        }

        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: url)
        self.urlSession = session
        self.webSocket = task
        task.resume()

        // Send auth after connection
        Task {
            do {
                // Socket.IO handshake
                try await sendRaw("40{\"auth\":{\"token\":\"\(config.gatewayToken)\"}}")
                isConnected = true
                config.gatewayConnected = true
                startReceiving()
            } catch {
                isConnected = false
                config.gatewayConnected = false
                self.error = "Connection failed: \(error.localizedDescription)"
            }
        }
    }

    func disconnect() {
        webSocket?.cancel(with: .normalClosure, reason: nil)
        webSocket = nil
        isConnected = false
        config.gatewayConnected = false
    }

    // MARK: - Send/Receive

    private func sendRaw(_ text: String) async throws {
        guard let ws = webSocket else { throw GatewayError.notConnected }
        try await ws.send(.string(text))
    }

    /// Send a socket.io event: 42["eventName", {payload}]
    private func sendEvent(_ event: String, payload: [String: Any]) async throws {
        let payloadData = try JSONSerialization.data(withJSONObject: payload)
        let payloadStr = String(data: payloadData, encoding: .utf8) ?? "{}"
        try await sendRaw("42[\"\(event)\",\(payloadStr)]")
    }

    private func startReceiving() {
        webSocket?.receive { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let message):
                    switch message {
                    case .string(let text):
                        self?.handleMessage(text)
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            self?.handleMessage(text)
                        }
                    @unknown default:
                        break
                    }
                    // Continue receiving
                    self?.startReceiving()

                case .failure(let error):
                    self?.isConnected = false
                    self?.config.gatewayConnected = false
                    self?.error = "WebSocket error: \(error.localizedDescription)"
                }
            }
        }
    }

    private func handleMessage(_ text: String) {
        // Socket.IO protocol:
        // "0" = connect
        // "2" = ping, respond with "3"
        // "3" = pong
        // "42" = event message
        if text == "2" {
            // Ping — respond with pong
            Task { try? await sendRaw("3") }
            return
        }

        if text.hasPrefix("42") {
            // Parse event: 42["eventName", {...}]
            let json = String(text.dropFirst(2))
            parseEvent(json)
        }
    }

    private func parseEvent(_ json: String) {
        guard let data = json.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: data) as? [Any],
              let eventName = array.first as? String else { return }

        let payload = array.count > 1 ? array[1] as? [String: Any] : nil

        switch eventName {
        case "chat":
            if let payload = payload {
                handleChatEvent(payload)
            }
        case "status":
            if let name = payload?["agentName"] as? String {
                agentName = name
            }
        default:
            break
        }
    }

    private func handleChatEvent(_ payload: [String: Any]) {
        guard let role = payload["role"] as? String else { return }

        let content: String
        if let text = payload["text"] as? String {
            content = text
        } else if let contentArray = payload["content"] as? [[String: Any]],
                  let firstText = contentArray.first?["text"] as? String {
            content = firstText
        } else {
            return
        }

        let msg = ChatMessage(
            id: payload["id"] as? String ?? UUID().uuidString,
            role: role,
            content: content,
            timestamp: ISO8601DateFormatter().string(from: Date()),
            sessionKey: nil
        )
        messages.append(msg)
    }

    // MARK: - Public API

    func sendMessage(_ content: String) async {
        guard isConnected else {
            error = "Not connected to gateway"
            return
        }

        // Add optimistic user message
        let userMsg = ChatMessage.userMessage(content)
        messages.append(userMsg)

        do {
            try await sendEvent("chat.send", payload: [
                "message": content,
                "sessionKey": config.sessionKey
            ])
        } catch {
            self.error = "Failed to send: \(error.localizedDescription)"
        }
    }

    func fetchHistory() async {
        guard isConnected else { return }
        do {
            try await sendEvent("chat.history", payload: [
                "sessionKey": config.sessionKey,
                "limit": 50
            ])
        } catch {
            self.error = "Failed to fetch history: \(error.localizedDescription)"
        }
    }

    func checkStatus() async {
        guard isConnected else { return }
        do {
            try await sendEvent("status", payload: [:])
        } catch {
            self.error = "Failed to get status: \(error.localizedDescription)"
        }
    }
}

// MARK: - Supporting Types

enum GatewayError: Error, LocalizedError {
    case notConnected
    case invalidURL
    case authFailed

    var errorDescription: String? {
        switch self {
        case .notConnected: return "Not connected to gateway"
        case .invalidURL: return "Invalid gateway URL"
        case .authFailed: return "Authentication failed"
        }
    }
}

// ChatSession defined in Models/Message.swift
