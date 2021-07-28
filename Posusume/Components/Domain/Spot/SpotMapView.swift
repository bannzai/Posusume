import SwiftUI
import Combine
import ComposableArchitecture
import MapKit

struct SpotMapState: Equatable {
    var center: CLLocationCoordinate2D = defaultRegion.center
    var span: CoordinateSpan = .init(span: defaultRegion.span)
    var region: MKCoordinateRegion { .init(center: center, span: .init(latitudeDelta: span.latitudeDelta, longitudeDelta: span.longitudeDelta)) }
    var geoPoint: GeoPoint { .init(coordinate: center) }

    var spots: [Spot] = []
    var error: EquatableError?

    var spotPost: SpotPostState? = nil
    var isPresentedSpotPostPage: Bool { spotPost != nil }
    var spotListState: SpotListState { SpotListState(spots: spots) }
}

enum SpotMapAction: Equatable {
    case regionChange(center: CLLocationCoordinate2D, span: CoordinateSpan)
    case fetch
    case watch
    case reload(Result<[Spot], EquatableError>)
    case presentSpotPost(Spot?)
    case spotPostAction(SpotPostAction)
    case spotPostPresentationDidChanged(Bool)
}

let spotMapReducer: Reducer<SpotMapState, SpotMapAction, SpotMapEnvironment> = .combine (
    spotPostReducer.optional().pullback(
        state: \.spotPost,
        action: /SpotMapAction.spotPostAction,
        environment: {
            SpotPostEnvironment(
                me: $0.me,
                mainQueue: .main,
                create: FirestoreDatabase.shared.create,
                update: FirestoreDatabase.shared.update,
                photoLibrary: photoLibrary
            )
        }
    ),
    .init { (state, action, environment) in
        func path() -> DatabaseCollectionPathBuilder<Spot> {
            // TODO: adjustment offset from span
            let offset: CLLocationDegrees = 3
            let pathBuilder = DatabaseCollectionPathBuilder<Spot>.spotsGroup(
                args: (
                    key: .location,
                    relations: [.geoRange(geoPoint: state.geoPoint, distance: 1)]
                )
            )
            return pathBuilder
        }
        
        struct WatchCanceller: Hashable { }
        struct FetchCanceller: Hashable { }
        struct RegionDidChangedCanceller: Hashable { }
        switch action {
        case let .regionChange(center, meters):
            return .merge(
                Effect(value: SpotMapAction.fetch)
                    .cancellable(id: RegionDidChangedCanceller())
                    .delay(for: 0.5, scheduler: environment.mainQueue)
                    .eraseToEffect(),
                Effect(value: SpotMapAction.watch)
                    .cancellable(id: RegionDidChangedCanceller())
                    .delay(for: 0.5, scheduler: environment.mainQueue)
                    .eraseToEffect()
            )
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
        case let .presentSpotPost(spot):
            switch spot {
            case nil:
                state.spotPost = SpotPostState(context: .create)
            case let spot?:
                state.spotPost = SpotPostState(context: .update(spot))
            }
            return .none
        case let .spotPostPresentationDidChanged(isPresent):
            if !isPresent {
                state.spotPost = nil
            }
            return .none
        case let .spotPostAction(action):
            switch action {
            case .dismiss:
                state.spotPost = nil
                return .none
            case _:
                return .none
            }
        }
    })

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
                        send: { .regionChange(center: $0.center, span: .init(span: $0.span)) }
                    ),
                    showsUserLocation: true,
                    annotationItems: viewStore.state.spots,
                    annotationContent: { spot in
                        MapAnnotation(coordinate: spot.coordinate) {
                            Text(spot.title)
                        }
                    }
                )

                VStack(spacing: -32) {
                    HStack {
                        Spacer()
                        Button {
                            viewStore.send(.presentSpotPost(nil))
                        } label: {
                            Image("addSpot")
                                .frame(width: 64, height: 64, alignment: .center)
                                .background(GradientColor.lower)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.trailing, 20)

                    ZStack {
                        BarnBottomSheet()
                        SpotList(
                            state: viewStore.state.spotListState
                        )
                        .frame(alignment: .bottom)
                        .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: BarnBottomSheet.height, alignment: .bottom)
                }
            }
            .onAppear { viewStore.send(.fetch) }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresentedSpotPostPage,
                    send: { .spotPostPresentationDidChanged($0) }
                ),
                content: {
                    IfLetStore(
                        store.scope(
                            state: \.spotPost,
                            action: {
                                .spotPostAction($0)
                            }
                        ),
                        then: SpotPostView.init(store:))
                }
            )
        }
    }
}


struct SpotMapView_Previews: PreviewProvider {
    static var previews: some View {
        SpotMapView(
            store: .init(
                initialState: .init(
                    spots: [
                        .init(id: SpotID(rawValue: "identifier"), location: .init(latitude: 10, longitude: 100), title: "spot", imageFileName: "")
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
        .init(id: SpotID(rawValue: "identifier\(offset)"), location: .init(latitude: 35.655164046, longitude: 139.740663704 + Double(offset) * 000000.1), title: "spot \(offset)", imageFileName: "")
    }
}
