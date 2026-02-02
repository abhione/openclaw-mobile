import SwiftUI

struct ChatView: View {
    @EnvironmentObject var config: AppConfiguration
    @StateObject private var gateway: GatewayService
    @State private var messageText = ""
    @State private var scrollToBottom = false

    init() {
        // Placeholder init — actual config injected via .environmentObject
        _gateway = StateObject(wrappedValue: GatewayService(config: AppConfiguration()))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                if !config.isConfigured {
                    unconfiguredView
                } else {
                    chatContent
                }
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppTheme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            updateGatewayConfig()
        }
        .onChange(of: config.gatewayURL) { _, _ in updateGatewayConfig() }
        .onChange(of: config.gatewayToken) { _, _ in updateGatewayConfig() }
    }

    // MARK: - Chat Content

    private var chatContent: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        if gateway.messages.isEmpty && !gateway.isLoading {
                            emptyStateView
                        }

                        ForEach(gateway.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }

                        if gateway.isLoading {
                            HStack {
                                ProgressView()
                                    .tint(AppTheme.accent)
                                Text("Thinking...")
                                    .font(AppTheme.captionFont)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            .padding()
                            .id("loading")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .refreshable {
                    await gateway.fetchHistory()
                }
                .onChange(of: gateway.messages.count) { _, _ in
                    withAnimation {
                        if let lastId = gateway.messages.last?.id {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()
                .background(AppTheme.textTertiary.opacity(0.3))

            ChatInputBar(text: $messageText, isLoading: gateway.isLoading) {
                await sendMessage()
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 100)
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.textTertiary)
            Text("No messages yet")
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.textSecondary)
            Text("Start a conversation with your OpenClaw agent")
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    // MARK: - Unconfigured View

    private var unconfiguredView: some View {
        VStack(spacing: 20) {
            Image(systemName: "gear.badge.xmark")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.textTertiary)
            Text("Gateway Not Configured")
                .font(AppTheme.headlineFont)
                .foregroundStyle(AppTheme.textPrimary)
            Text("Go to Settings to enter your\nOpenClaw Gateway URL and token.")
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Actions

    private func sendMessage() async {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messageText = ""
        _ = await gateway.sendMessage(text)
    }

    private func updateGatewayConfig() {
        // Re-create the service with current config
        // In production you'd use dependency injection; here we work with @EnvironmentObject
    }
}

#Preview {
    ChatView()
        .environmentObject(AppConfiguration())
}
