import SwiftUI
import Combine
import ComposableArchitecture
import MapKit
import CoreLocation

struct LocationSelectState: Equatable {
    var center: CLLocationCoordinate2D = defaultRegion.center
    var span: CoordinateSpan = .init(span: defaultRegion.span)
    var region: MKCoordinateRegion { .init(center: center, span: .init(latitudeDelta: span.latitudeDelta, longitudeDelta: span.longitudeDelta)) }
}

enum LocationSelectAction: Equatable {
    case regionChange(center: CLLocationCoordinate2D, span: CoordinateSpan)
}

struct LocationSelectEnvironment {
    
}

let locationSelectReducer: Reducer<LocationSelectState, LocationSelectAction, LocationSelectEnvironment> = .init { state, action, environment in
    switch action {
    case .regionChange:
        return .none
    }
}
struct LocationSelectView: View {
    let store: Store<LocationSelectState, LocationSelectAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                LocationSearchBar()
                Map(
                    coordinateRegion: viewStore.binding(
                        get: \.region,
                        send: { .regionChange(center: $0.center, span: .init(span: $0.span)) }
                    ),
                    showsUserLocation: true
                )
            }
        }
    }
}

struct LocationSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectView(
            store: .init(initialState: .init(),
                      reducer: locationSelectReducer,
                      environment: LocationSelectEnvironment()
                )
        )
    }
}
