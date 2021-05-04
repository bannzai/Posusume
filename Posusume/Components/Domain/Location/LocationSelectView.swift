import SwiftUI
import Combine
import ComposableArchitecture
import MapKit
import CoreLocation

struct LocationSelectState: Equatable {
    var searchText: String = ""
    var marks: [PlaceMark] = []
    var selected: PlaceMark? = nil
    var error: EquatableError? = nil
    var userLocation: CLLocationCoordinate2D? = nil
    
    enum Alert: Int, Identifiable {
        case notPermission
        case openSettingApp
        var id: Int { rawValue }
    }
    var alert: Alert? = nil
}

enum LocationSelectAction: Equatable {
    case search(String)
    case searched(Result<[PlaceMark], EquatableError>)
    case selectedCurrentLocationRow
    case selected(PlaceMark)
    case startTrackingLocation
    case setUserLocation(Result<CLLocation, EquatableError>)
    case requestedAuthentification(CLAuthorizationStatus)
}

struct LocationSelectEnvironment {
    let geocoder: Geocoder
    let locationManager: LocationManager
}

let locationSelectReducer: Reducer<LocationSelectState, LocationSelectAction, LocationSelectEnvironment> = .init { state, action, environment in
    switch action {
    case let .search(text):
        state.searchText = text
        return Effect(environment.geocoder.geocoder(address: text))
            .mapError(EquatableError.init(error:))
            .catchToEffect()
            .map(LocationSelectAction.searched)
            .eraseToEffect()
    case let .searched(.success(marks)):
        state.marks = []
        return .none
    case .searched(.failure):
        state.marks = []
        return .none
    case let .selected(mark):
        state.selected = mark
        return .none
    case .selectedCurrentLocationRow:
        switch environment.locationManager.prepareActionType() {
        case nil:
            return Effect(value: .startTrackingLocation)
        case .openSettingApp:
            return .none
        case .requiredAutentification:
            return environment.locationManager.requestAuthorization().map(LocationSelectAction.requestedAuthentification).eraseToEffect()
        }
    case .startTrackingLocation:
        return Effect(environment.locationManager.userLocation())
            .mapError(EquatableError.init(error:))
            .catchToEffect()
            .map(LocationSelectAction.setUserLocation)
            .eraseToEffect()
    case .requestedAuthentification(let status):
        switch status {
        case .authorizedAlways:
            return Effect(value: .startTrackingLocation)
        case .authorizedWhenInUse:
            return Effect(value: .startTrackingLocation)
        case .denied:
            state.alert = .notPermission
            return .none
        case .notDetermined:
            fatalError("unexpected notDetermined permission. requestedAuthentification should call after request permission")
        case .restricted:
            state.alert = .openSettingApp
            return .none
        @unknown default:
            assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            return .none
        }
    case let .setUserLocation(.success(location)):
        state.userLocation = location.coordinate
        return .none
    case let .setUserLocation(.failure(error)):
        state.error = error
        return .none
    }
}

struct LocationSelectView: View {
    let store: Store<LocationSelectState, LocationSelectAction>
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVStack {
                    Section(header: Text("Header")) {
                        SearchBar(
                            isEditing: true,
                            text: viewStore.binding(
                                get: \.searchText,
                                send: {
                                    .search($0)
                                }
                            )
                        )
                    }
                    row("現在地を選択")
                        .onTapGesture {
                            viewStore.send(.selectedCurrentLocationRow)
                        }
                    ForEach(0..<viewStore.marks.count) { i in
                        HStack {
                            row(formatForLocation(mark: viewStore.marks[i]))
                                .onTapGesture {
                                    viewStore.send(.selected(viewStore.marks[i]))
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
    
    func row(_ name: String) -> Text {
        Text(name).font(.footnote)
    }
}

func formatForLocation(mark: PlaceMark) -> String {
    if !mark.name.isEmpty {
        return "\(mark.name): \(mark.address.address)"
    }
    return mark.address.address
}

struct LocationSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectView(
            store: .init(
                initialState: .init(),
                reducer: locationSelectReducer,
                environment: LocationSelectEnvironment(
                    geocoder: geocoder,
                    locationManager: locationManager
                )
            )
        )
    }
}
