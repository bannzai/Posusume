import SwiftUI
import MapKit
import Combine

struct LoginView: View {
    @EnvironmentObject private var auth: AuthViewModel

    @State var region: MKCoordinateRegion = defaultRegion

    var body: some View {
        // NOTE: Currently Posusume provided only anonymous login. It means about LoginView only keep empty map view until authorized
        Map(coordinateRegion: $region)
            .onAppear(perform: {
                _ = auth.signInAnonymously()
            })
            .edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
