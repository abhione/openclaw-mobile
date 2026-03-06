import SwiftUI

// MARK: - App Configuration

@MainActor
final class AppConfiguration: ObservableObject {
    // Non-sensitive settings stored in UserDefaults via @AppStorage
    @AppStorage("gatewayURL") var gatewayURL: String = ""
    @AppStorage("kgAPIURL") var kgAPIURL: String = ""
    @AppStorage("sessionKey") var sessionKey: String = "mobile"

    // Sensitive tokens stored in the iOS Keychain — NOT UserDefaults.
    // Changes are written to Keychain via didSet.
    @Published var gatewayToken: String = "" {
        didSet { KeychainHelper.save(gatewayToken, forKey: "gatewayToken") }
    }
    @Published var kgAPIToken: String = "" {
        didSet { KeychainHelper.save(kgAPIToken, forKey: "kgAPIToken") }
    }

    @Published var gatewayConnected: Bool = false
    @Published var kgConnected: Bool = false
    @Published var agentName: String = ""

    init() {
        // Load tokens from Keychain on launch.
        // Using the Published wrapper's initialValue to avoid triggering didSet
        // (and a redundant Keychain write) during initialization.
        let storedGatewayToken = KeychainHelper.load(forKey: "gatewayToken") ?? ""
        let storedKGAPIToken = KeychainHelper.load(forKey: "kgAPIToken") ?? ""
        self._gatewayToken = Published(initialValue: storedGatewayToken)
        self._kgAPIToken = Published(initialValue: storedKGAPIToken)
    }

    var isConfigured: Bool {
        !gatewayURL.isEmpty && !gatewayToken.isEmpty
    }

    var isKGConfigured: Bool {
        !kgAPIURL.isEmpty
    }

    var normalizedGatewayURL: String {
        var url = gatewayURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if url.hasSuffix("/") { url.removeLast() }
        return url
    }

    var normalizedKGURL: String {
        var url = kgAPIURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if url.hasSuffix("/") { url.removeLast() }
        return url
    }

    /// Returns true if the gateway URL uses an encrypted scheme (https/wss).
    var gatewayURLIsSecure: Bool {
        let lower = normalizedGatewayURL.lowercased()
        return lower.hasPrefix("https://") || lower.hasPrefix("wss://")
    }

    /// Returns true if the KG API URL uses an encrypted scheme (https).
    var kgURLIsSecure: Bool {
        normalizedKGURL.lowercased().hasPrefix("https://")
    }
}
