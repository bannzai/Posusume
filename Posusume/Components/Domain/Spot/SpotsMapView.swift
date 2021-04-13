import SwiftUI
import Combine
import ComposableArchitecture
import MapKit

struct SpotMapState: Equatable {
    var spots: [Spot] = []
    var error: EquatableError?
}

enum SpotMapAction: Equatable {
    case fetch(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    case fetched(Result<[Spot], EquatableError>)
}

let spotMapReducer = Reducer<SpotMapState, SpotMapAction, SpotMapEnvironment> { (state, action, environment) in
    struct Canceller: Hashable { }
    switch action {
    case let .fetch(latitude, longitude):
        let offset: CLLocationDegrees = 3
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
}

struct SpotMapEnvironment {
    let me: Me
    let fetchList: (DatabaseCollectionPathBuilder<Spot>) -> AnyPublisher<[Spot], Error>
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

struct SpotMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.655164046, longitude: 139.740663704), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    let store: Store<SpotMapState, SpotMapAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                Map(coordinateRegion: viewStore.binding(get: ))
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
                .onAppear { viewStore.send(.fetch(latitude: region.center.latitude, longitude: region.center.longitude))}
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
                reducer: SpotMapReducer,
                environment: SpotMapEnvironment(
                    me: .init(id: Me.ID(rawValue: "1")),
                    fetchList: { _ in Future(value: spots).eraseToAnyPublisher() },
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
        .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 300))
    }
    static var spots: [Spot] = (0..<10).map {
        .init(id: SpotID(rawValue: "identifier\($0)"), latitude: 100, longitude: 100, name: "spot \($0)", imagePath: nil)
    }
}
