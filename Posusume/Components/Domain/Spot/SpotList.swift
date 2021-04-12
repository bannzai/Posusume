import SwiftUI
import Combine
import ComposableArchitecture

struct SpotListState: Equatable {
    var spots: [Spot] = []
    var error: EquatableError?
}

enum SpotListAction: Equatable {
    case onAppear
    case fetch
    case fetched(Result<[Spot], EquatableError>)
}

let spotListReducer = Reducer<SpotListState, SpotListAction, SpotListEnvironment> { (state, action, environment) in
    struct Canceller: Hashable { }
    switch action {
    case .onAppear:
        return Effect(value: .fetch).eraseToEffect()
    case .fetch:
        return environment.auth.auth()
            .map(DatabaseCollectionPathBuilder<Spot>.userSpots(userID:))
            .flatMap(environment.fetchList)
            .mapError(EquatableError.init(error:))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SpotListAction.fetched)
    case .fetched(.success(let spots)):
        state.spots = spots
        return .none
    case .fetched(.failure(let error)):
        state.error = error
        return .none
    }
}

struct SpotListEnvironment {
    let auth: Auth
    let fetchList: (DatabaseCollectionPathBuilder<Spot>) -> AnyPublisher<[Spot], Error>
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

struct SpotList: View {
    typealias Cell = SpotListCell

    let store: Store<SpotListState, SpotListAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewStore.state.spots) { spot in
                        Cell(spot: spot)
                    }
                }
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}


struct MockAuth: Auth {
    func auth() -> AnyPublisher<UserID, Error> {
        Future(value: UserID(rawValue: "1"))
            .eraseToAnyPublisher()
    }
}

struct SpotList_Previews: PreviewProvider {
    static var previews: some View {
        SpotList(
            store: .init(
                initialState: .init(
                    spots: [
                        .init(id: SpotID(rawValue: "identifier"), latitude: 100, longitude: 100, name: "spot", imagePath: nil)
                    ],
                    error: nil
                ),
                reducer: spotListReducer,
                environment: SpotListEnvironment(
                    auth: MockAuth(),
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
