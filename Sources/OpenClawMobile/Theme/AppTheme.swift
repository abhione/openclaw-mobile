import SwiftUI

// MARK: - OpenClaw App Theme

enum AppTheme {
    // MARK: Colors

    static let background = Color(hex: "0a0f1a")
    static let cardBackground = Color(hex: "141b2d")
    static let accent = Color(hex: "3b82f6")
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.7)
    static let textTertiary = Color(white: 0.5)

    // Status Colors
    static let statusCompleted = Color(hex: "22c55e")
    static let statusInProgress = Color(hex: "3b82f6")
    static let statusPending = Color(hex: "eab308")
    static let statusBlocked = Color(hex: "ef4444")
    static let statusPlanned = Color(hex: "8b5cf6")

    // Priority Colors
    static let priorityCritical = Color(hex: "ef4444")
    static let priorityHigh = Color(hex: "f97316")
    static let priorityMedium = Color(hex: "eab308")
    static let priorityLow = Color(hex: "22c55e")

    // Chat Colors
    static let userBubble = Color(hex: "3b82f6")
    static let assistantBubble = Color(hex: "1e293b")

    // MARK: Fonts

    static let titleFont = Font.system(size: 28, weight: .bold, design: .rounded)
    static let headlineFont = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 16, weight: .regular)
    static let captionFont = Font.system(size: 13, weight: .medium)
    static let badgeFont = Font.system(size: 11, weight: .bold)

    // MARK: Layout

    static let cornerRadius: CGFloat = 12
    static let smallCornerRadius: CGFloat = 8
    static let cardPadding: CGFloat = 16
    static let spacing: CGFloat = 12
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.cardPadding)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
