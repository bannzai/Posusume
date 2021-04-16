import SwiftUI
import Combine
import ComposableArchitecture
import MapKit
import FirebaseFirestore

let defaultRegion = MKCoordinateRegion(
    center: .init(latitude: 35.655164046, longitude: 139.740663704),
    span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
)
struct SpotMapState: Equatable {
    var center: CLLocationCoordinate2D = defaultRegion.center
    var span: CoordinateSpan = .init(latitudeDelta: defaultRegion.span.latitudeDelta, longitudeDelta: defaultRegion.span.longitudeDelta)
    var region: MKCoordinateRegion { .init(center: center, span: .init(latitudeDelta: span.latitudeDelta, longitudeDelta: span.longitudeDelta)) }
    var geoPoint: GeoPoint { .init(coordinate: center) }
    var spots: [Spot] = []
    var error: EquatableError?

    var spotListState: SpotListState { SpotListState(spots: spots) }
}

enum SpotMapAction: Equatable {
    case regionChange(center: CLLocationCoordinate2D, span: CoordinateSpan)
    case fetch
    case watch
    case reload(Result<[Spot], EquatableError>)
}

let spotMapReducer = Reducer<SpotMapState, SpotMapAction, SpotMapEnvironment> { (state, action, environment) in
    func path() -> DatabaseCollectionPathBuilder<Spot> {
        // TODO: adjustment offset from span
        let offset: CLLocationDegrees = 3
        let latitude = state.center.latitude
        let longitude = state.center.longitude
        let pathBuilder = DatabaseCollectionPathBuilder<Spot>.spotsGroup(args: [
            (.latitude, .lessOrEqual(latitude + offset)),
            (.longitude, .lessOrEqual(longitude + offset)),
            (.latitude, .greaterOrEqual(latitude - offset)),
            (.longitude, .greaterOrEqual(longitude - offset)),
        ])
        return pathBuilder
    }

    struct WatchCanceller: Hashable { }
    struct FetchCanceller: Hashable { }
    switch action {
    case let .regionChange(center, meters):
        return .none
    case .fetch:
        return environment.fetchList(path())
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .cancellable(id: FetchCanceller())
            .map(SpotMapAction.reload)
    case .watch:
        return environment.watchList(path())
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .cancellable(id: WatchCanceller())
            .map(SpotMapAction.reload)
    case .reload(.success(let spots)):
        state.spots = spots
        return .none
    case .reload(.failure(let error)):
        state.error = error
        return .none
    }
}

struct SpotMapEnvironment {
    let me: Me
    let fetchList: (DatabaseCollectionPathBuilder<Spot>) -> AnyPublisher<[Spot], Error>
    let watchList: (DatabaseCollectionPathBuilder<Spot>) -> AnyPublisher<[Spot], Error>
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

struct SpotMapView: View {
    let store: Store<SpotMapState, SpotMapAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                Map(
                    coordinateRegion: viewStore.binding(
                        get: \.region,
                        send: { .regionChange(center: $0.center, span: .init(latitudeDelta: $0.span.longitudeDelta, longitudeDelta: $0.span.longitudeDelta))
                        }
                    ),
                    showsUserLocation: true,
                    annotationItems: viewStore.state.spots,
                    annotationContent: { spot in
                        MapAnnotation(coordinate: spot.coordinate) {
                            Text(spot.name)
                        }
                    }
                )
                ZStack {
                    BarnBottomSheet()
                    SpotList(
                        state: viewStore.state.spotListState
                    )
                    .frame(alignment: .bottom)
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height, alignment: .bottom)
                .onAppear { viewStore.send(.fetch) }
            }
        }
    }
}


struct SpotMapView_Previews: PreviewProvider {
    static var previews: some View {
        SpotMapView(
            store: .init(
                initialState: .init(
                    spots: [
                        .init(id: SpotID(rawValue: "identifier"), location: .init(latitude: 100, longitude: 100), name: "spot", imageFileName: "")
                    ],
                    error: nil
                ),
                reducer: spotMapReducer,
                environment: SpotMapEnvironment(
                    me: .init(id: Me.ID(rawValue: "1")),
                    fetchList: { _ in Future(value: spots).eraseToAnyPublisher() },
                    watchList: { _ in Future(value: spots).eraseToAnyPublisher() },
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
    static var spots: [Spot] = (0..<10).map { offset in
        .init(id: SpotID(rawValue: "identifier\(offset)"), location: .init(latitude: 35.655164046, longitude: 139.740663704 + Double(offset) * 000000.1), name: "spot \(offset)", imageFileName: "")
    }
}
