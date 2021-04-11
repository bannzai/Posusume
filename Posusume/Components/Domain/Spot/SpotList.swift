import SwiftUI
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

let spotListReducer = Reducer<SpotListState, SpotListAction, VoidEnvironment> { (state, action, _) in
    struct Canceller: Hashable { }
    switch action {
    case .onAppear:
        return Effect(value: .fetch).eraseToEffect()
    case .fetch:
        return auth.auth()
            .map(DatabaseCollectionPathBuilder<Spot>.userSpots(userID:))
            .flatMap(Database.shared.fetchList(path:))
            .map(\.compacted)
            .mapError(EquatableError.init(error:))
            .catchToEffect()
            .map(SpotListAction.fetched)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case .fetched(.success(let spots)):
        state.spots = spots
        return .none
    case .fetched(.failure(let error)):
        state.error = error
        return .none
    }
}

struct SpotList: View {
    typealias Cell = SpotListCell
    var spots: [Spot] = [
        .init(id: SpotID(rawValue: "identifier1")!, latitude: 100, longitude: 100, name: "spot 1", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier2")!, latitude: 100, longitude: 100, name: "spot 2", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier3")!, latitude: 100, longitude: 100, name: "spot 3", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier4")!, latitude: 100, longitude: 100, name: "spot 4", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier5")!, latitude: 100, longitude: 100, name: "spot 5", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier6")!, latitude: 100, longitude: 100, name: "spot 6", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier7")!, latitude: 100, longitude: 100, name: "spot 7", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier8")!, latitude: 100, longitude: 100, name: "spot 8", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier9")!, latitude: 100, longitude: 100, name: "spot 9", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier10")!, latitude: 100, longitude: 100, name: "spot 10", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier11")!, latitude: 100, longitude: 100, name: "spot 11", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier12")!, latitude: 100, longitude: 100, name: "spot 12", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier13")!, latitude: 100, longitude: 100, name: "spot 13", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier14")!, latitude: 100, longitude: 100, name: "spot 14", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier15")!, latitude: 100, longitude: 100, name: "spot 15", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier16")!, latitude: 100, longitude: 100, name: "spot 16", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier17")!, latitude: 100, longitude: 100, name: "spot 17", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier18")!, latitude: 100, longitude: 100, name: "spot 18", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier19")!, latitude: 100, longitude: 100, name: "spot 19", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier20")!, latitude: 100, longitude: 100, name: "spot 20", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier21")!, latitude: 100, longitude: 100, name: "spot 21", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier22")!, latitude: 100, longitude: 100, name: "spot 22", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier23")!, latitude: 100, longitude: 100, name: "spot 23", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier24")!, latitude: 100, longitude: 100, name: "spot 24", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier25")!, latitude: 100, longitude: 100, name: "spot 25", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier26")!, latitude: 100, longitude: 100, name: "spot 26", imagePath: nil),
        .init(id: SpotID(rawValue: "identifier27")!, latitude: 100, longitude: 100, name: "spot 27", imagePath: nil),
    ]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(spots) { spot in
                    Cell(spot: spot)
                }
            }
        }
    }
}


struct SpotList_Previews: PreviewProvider {
    static var previews: some View {
        SpotList()
    }
}
