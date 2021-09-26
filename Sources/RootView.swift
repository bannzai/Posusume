import SwiftUI
import MapKit
import Combine

struct RootView: View {
    @StateObject private var auth = AuthViewModel()

    var body: some View {
        if let me = auth.me {
            SpotMapView()
                .environment(\.me, me)
        } else {
            LoginView()
                .environmentObject(auth)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
