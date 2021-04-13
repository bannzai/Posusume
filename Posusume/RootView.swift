//
//  RootView.swift
//  posusume
//
//  Created by Yudai.Hirose on 2021/03/28.
//

import SwiftUI
import MapKit

struct RootView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.655164046, longitude: 139.740663704), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Map(coordinateRegion: $region)
            ZStack {
                BarnBottomSheet()
                SpotList(
                    store: .init(
                        initialState: .init(),
                        reducer: spotListReducer,
                        environment: SpotListEnvironment(
                            auth: auth,
                            fetchList: FirestoreDatabase.shared.fetchList,
                            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                        )
                    )
                )
                .frame(alignment: .bottom)
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height, alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.all)
    }
}



struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
