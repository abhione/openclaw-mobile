import SwiftUI

struct ContentView: View {
    @EnvironmentObject var config: AppConfiguration
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Chat", systemImage: "bubble.left.and.bubble.right", value: 0) {
                ChatView()
            }

            Tab("Tasks", systemImage: "checklist", value: 1) {
                TasksView()
            }

            Tab("Graph", systemImage: "circle.grid.cross", value: 2) {
                GraphView()
            }

            Tab("Settings", systemImage: "gear", value: 3) {
                SettingsView()
            }
        }
        .tint(AppTheme.accent)
        .onAppear {
            configureTabBarAppearance()
        }
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppTheme.background)

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(AppTheme.textTertiary)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.textTertiary)]
        itemAppearance.selected.iconColor = UIColor(AppTheme.accent)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.accent)]

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .environmentObject(AppConfiguration())
}
