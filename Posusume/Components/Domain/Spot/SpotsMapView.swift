import SwiftUI
import Combine
import ComposableArchitecture
import MapKit

struct SpotMapState: Equatable {
    var center: CLLocationCoordinate2D = .init(latitude: 35.655164046, longitude: 139.740663704)
    var span: CoordinateSpan = .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
    var region: MKCoordinateRegion { .init(center: center, span: .init(latitudeDelta: span.latitudeDelta, longitudeDelta: span.longitudeDelta)) }
    var spots: [Spot] = []
    var error: EquatableError?

    var spotListState = SpotListState()
}

enum SpotMapAction: Equatable {
    case regionChange(center: CLLocationCoordinate2D, span: CoordinateSpan)
    case fetch
    case fetched(Result<[Spot], EquatableError>)
}

let spotMapReducer = Reducer<SpotMapState, SpotMapAction, SpotMapEnvironment>.combine(
    .init { (state, action, environment) in
        struct Canceller: Hashable { }
        switch action {
        case let .regionChange(center, meters):
            return .none
        case .fetch:
            // TODO: adjustment offset from span
            let offset: CLLocationDegrees = 3
            let latitude = state.center.latitude
            let longitude = state.center.longitude
            let pathBuilder = DatabaseCollectionPathBuilder<Spot>.spots(args: [
                (.latitude, .lessOrEqual(latitude + offset)),
                (.longitude, .lessOrEqual(longitude + offset)),
                (.latitude, .greaterOrEqual(latitude - offset)),
                (.longitude, .greaterOrEqual(longitude - offset)),
            ])
            return environment.fetchList(pathBuilder)
                .mapError(EquatableError.init(error:))
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SpotMapAction.fetched)
        case .fetched(.success(let spots)):
            state.spots = spots
            return .none
        case .fetched(.failure(let error)):
            state.error = error
            return .none
        }
    },
    spotListReducer.pullback(
        state: \.spotListState,
        action: <#T##CasePath<GlobalAction, SpotListAction>#>,
        environment: <#T##(GlobalEnvironment) -> SpotListEnvironment#>
    )
)

struct SpotMapEnvironment {
    let me: Me
    let fetchList: (DatabaseCollectionPathBuilder<Spot>) -> AnyPublisher<[Spot], Error>
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

struct SpotMapView: View {
    let store: Store<SpotMapState, SpotMapAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                Map(coordinateRegion: viewStore.binding(
                        get: \.region,
                        send: { .regionChange(center: $0.center, span: .init(latitudeDelta: $0.span.longitudeDelta, longitudeDelta: $0.span.longitudeDelta))
                        }
                ))
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
                        .init(id: SpotID(rawValue: "identifier"), latitude: 100, longitude: 100, name: "spot", imagePath: nil)
                    ],
                    error: nil
                ),
                reducer: spotMapReducer,
                environment: SpotMapEnvironment(
                    me: .init(id: Me.ID(rawValue: "1")),
                    fetchList: { _ in Future(value: spots).eraseToAnyPublisher() },
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
    static var spots: [Spot] = (0..<10).map {
        .init(id: SpotID(rawValue: "identifier\($0)"), latitude: 100, longitude: 100, name: "spot \($0)", imagePath: nil)
    }
}
