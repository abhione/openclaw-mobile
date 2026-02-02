import SwiftUI

struct StatusBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(AppTheme.badgeFont)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}

#Preview {
    HStack(spacing: 8) {
        StatusBadge(text: "In Progress", color: AppTheme.statusInProgress)
        StatusBadge(text: "High", color: AppTheme.priorityHigh)
        StatusBadge(text: "Completed", color: AppTheme.statusCompleted)
        StatusBadge(text: "Blocked", color: AppTheme.statusBlocked)
    }
    .padding()
    .background(AppTheme.background)
}
