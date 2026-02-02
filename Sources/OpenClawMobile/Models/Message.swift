import Foundation

// MARK: - Chat Message

struct ChatMessage: Codable, Identifiable, Sendable {
    let id: String
    let role: String
    let content: String
    let timestamp: String?
    let sessionKey: String?

    enum CodingKeys: String, CodingKey {
        case id, role, content, timestamp
        case sessionKey = "session_key"
    }

    var isUser: Bool {
        role.lowercased() == "user"
    }

    var isAssistant: Bool {
        role.lowercased() == "assistant"
    }

    var formattedTime: String {
        guard let timestamp = timestamp else { return "" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: timestamp) {
            let displayFormatter = DateFormatter()
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        // Try without fractional seconds
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: timestamp) {
            let displayFormatter = DateFormatter()
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return ""
    }

    static func userMessage(_ content: String, sessionKey: String? = nil) -> ChatMessage {
        ChatMessage(
            id: UUID().uuidString,
            role: "user",
            content: content,
            timestamp: ISO8601DateFormatter().string(from: Date()),
            sessionKey: sessionKey
        )
    }
}

// MARK: - Session

struct ChatSession: Codable, Identifiable, Sendable {
    let id: String
    let key: String
    let channel: String?
    let agentName: String?
    let createdAt: String?
    let lastActivity: String?

    enum CodingKeys: String, CodingKey {
        case id, key, channel
        case agentName = "agent_name"
        case createdAt = "created_at"
        case lastActivity = "last_activity"
    }
}

// MARK: - Gateway Status

struct GatewayStatus: Codable, Sendable {
    let status: String?
    let version: String?
    let agentName: String?
    let uptime: String?

    enum CodingKeys: String, CodingKey {
        case status, version
        case agentName = "agent_name"
        case uptime
    }
}

// MARK: - Message Send Response

struct MessageResponse: Codable, Sendable {
    let response: String?
    let messageId: String?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case response
        case messageId = "message_id"
        case error
    }
}
