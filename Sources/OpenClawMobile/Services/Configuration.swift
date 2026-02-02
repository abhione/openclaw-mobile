import SwiftUI

// MARK: - App Configuration

@MainActor
final class AppConfiguration: ObservableObject {
    @AppStorage("gatewayURL") var gatewayURL: String = ""
    @AppStorage("gatewayToken") var gatewayToken: String = ""
    @AppStorage("kgAPIURL") var kgAPIURL: String = ""
    @AppStorage("kgAPIToken") var kgAPIToken: String = "enigma-kg-local"
    @AppStorage("sessionKey") var sessionKey: String = "mobile"

    @Published var gatewayConnected: Bool = false
    @Published var kgConnected: Bool = false
    @Published var agentName: String = ""

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
}
