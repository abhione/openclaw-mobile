import SwiftUI

@main
struct OpenClawMobileApp: App {
    @StateObject private var config = AppConfiguration()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(config)
                .preferredColorScheme(.dark)
        }
    }
}
