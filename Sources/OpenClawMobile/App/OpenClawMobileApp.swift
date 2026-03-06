import SwiftUI

// TODO: [Xcode target dependency] Once this package is wrapped in an Xcode app target, add an
// Info.plist entry with NSAppTransportSecurity → NSAllowsArbitraryLoads: false (the default).
// This enforces App Transport Security (ATS) system-wide, blocking all plain HTTP at the OS
// level regardless of what URLSession configuration is used.

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
