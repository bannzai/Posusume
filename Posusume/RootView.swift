import SwiftUI
import MapKit
import Combine

struct RootView: View {
    @ViewBuilder public var body: some View {
        EmptyView()
//        IfLetStore(self.store.scope(state: { $0.login }, action: RootAction.login)) { store in
//            LoginView(store: store)
//        }
//        .edgesIgnoringSafeArea(.all)
//
//        IfLetStore(self.store.scope(state: { $0.spots }, action: RootAction.spots)) { store in
//            SpotMapView(store: store)
//        }
//        .edgesIgnoringSafeArea(.all)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
