import UIKit
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirebase()
        auth.auth { (result) in
            switch result {
            case .success:
                print("auth is success")
            case .failure(let error):
                print("auth is failure \(error.localizedDescription)")
            }
        }
        return true
    }
}

private func setupFirebase() {
    #if DEBUG
    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")!)!)
    #else
    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")!)!)
    #endif
}

