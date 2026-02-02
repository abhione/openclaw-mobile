import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    let isLoading: Bool
    let onSend: () async -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            TextField("Message...", text: $text, axis: .vertical)
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textPrimary)
                .lineLimit(1...5)
                .focused($isFocused)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isFocused ? AppTheme.accent.opacity(0.5) : Color.clear, lineWidth: 1)
                )

            Button {
                Task {
                    await onSend()
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(canSend ? AppTheme.accent : AppTheme.textTertiary)
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(AppTheme.background)
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
}

#Preview {
    VStack {
        Spacer()
        ChatInputBar(text: .constant("Hello"), isLoading: false) {
            // send
        }
    }
    .background(AppTheme.background)
}
