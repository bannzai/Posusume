import SwiftUI
import Combine
import ComposableArchitecture

struct SpotListState: Equatable {
    var spots: [Spot] = []
}

struct SpotList: View {
    typealias Cell = SpotListCell

    let state: SpotListState
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(state.spots) { spot in
                    Cell(spot: spot)
                }
            }
        }
    }
}

struct SpotList_Previews: PreviewProvider {
    static var previews: some View {
        SpotList(
            state: .init(spots: spots)
        )
        .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 300))
    }
    static var spots: [Spot] = (0..<10).map {
        .init(id: SpotID(rawValue: "identifier\($0)"), latitude: 100, longitude: 100, name: "spot \($0)", imageFileName: "")
    }
}
