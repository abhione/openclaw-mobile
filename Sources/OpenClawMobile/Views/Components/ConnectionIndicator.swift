import SwiftUI

struct ConnectionIndicator: View {
    let isConnected: Bool

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isConnected ? AppTheme.statusCompleted : AppTheme.statusBlocked)
                .frame(width: 8, height: 8)

            Text(isConnected ? "Connected" : "Disconnected")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(isConnected ? AppTheme.statusCompleted : AppTheme.statusBlocked)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background((isConnected ? AppTheme.statusCompleted : AppTheme.statusBlocked).opacity(0.12))
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 12) {
        ConnectionIndicator(isConnected: true)
        ConnectionIndicator(isConnected: false)
    }
    .padding()
    .background(AppTheme.background)
}
