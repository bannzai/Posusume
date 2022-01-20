import SwiftUI
import Application

@main
struct PosusumeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        return WindowGroup {
            RootView()
        }
    }
}
