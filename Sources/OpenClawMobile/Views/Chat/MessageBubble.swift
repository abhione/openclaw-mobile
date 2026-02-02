import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(AppTheme.bodyFont)
                    .foregroundStyle(AppTheme.textPrimary)
                    .textSelection(.enabled)

                if !message.formattedTime.isEmpty {
                    Text(message.formattedTime)
                        .font(.system(size: 11))
                        .foregroundStyle(message.isUser ? Color.white.opacity(0.6) : AppTheme.textTertiary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(message.isUser ? AppTheme.userBubble : AppTheme.assistantBubble)
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )

            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    VStack(spacing: 8) {
        MessageBubble(message: ChatMessage(
            id: "1",
            role: "user",
            content: "Hello, what's the weather today?",
            timestamp: nil,
            sessionKey: nil
        ))
        MessageBubble(message: ChatMessage(
            id: "2",
            role: "assistant",
            content: "It's sunny with a high of 72°F. Perfect weather for a walk!",
            timestamp: nil,
            sessionKey: nil
        ))
    }
    .padding()
    .background(AppTheme.background)
}
