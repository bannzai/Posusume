import Foundation
import SwiftUI
import MapKit

public struct RequireLocationAuthorizationView: View {
    public var body: some View {
        EmptyView()
    }
}

private func openSetting() {
    let settingURL = URL(string: UIApplication.openSettingsURLString)!
    if UIApplication.shared.canOpenURL(settingURL) {
        UIApplication.shared.open(settingURL)
    }
}
