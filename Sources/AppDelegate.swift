import UIKit
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        if !isPreview {
            setupFirebase()
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

private func setupFirebase() {
    #if DEBUG
    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")!)!)
    #else
    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")!)!)
    #endif
}

let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
