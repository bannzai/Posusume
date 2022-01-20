import UIKit
import Firebase

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        if !isPreview {
            FirebaseApp.configure()
        }
        return true
    }
}

func setupAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .clear
    appearance.shadowColor = nil
    appearance.shadowImage = nil
    appearance.backgroundImage = nil
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
