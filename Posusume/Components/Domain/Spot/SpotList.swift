import SwiftUI

struct SpotList: View {
    typealias Cell = SpotListCell
    var spots: [Spot] = [
        .init(id: "identifier1", latitude: 100, longitude: 100, name: "spot 1", imagePath: nil),
        .init(id: "identifier2", latitude: 100, longitude: 100, name: "spot 2", imagePath: nil),
        .init(id: "identifier3", latitude: 100, longitude: 100, name: "spot 3", imagePath: nil),
        .init(id: "identifier4", latitude: 100, longitude: 100, name: "spot 4", imagePath: nil),
        .init(id: "identifier5", latitude: 100, longitude: 100, name: "spot 5", imagePath: nil),
        .init(id: "identifier6", latitude: 100, longitude: 100, name: "spot 6", imagePath: nil),
        .init(id: "identifier7", latitude: 100, longitude: 100, name: "spot 7", imagePath: nil),
        .init(id: "identifier8", latitude: 100, longitude: 100, name: "spot 8", imagePath: nil),
        .init(id: "identifier9", latitude: 100, longitude: 100, name: "spot 9", imagePath: nil),
        .init(id: "identifier10", latitude: 100, longitude: 100, name: "spot 10", imagePath: nil),
        .init(id: "identifier11", latitude: 100, longitude: 100, name: "spot 11", imagePath: nil),
        .init(id: "identifier12", latitude: 100, longitude: 100, name: "spot 12", imagePath: nil),
        .init(id: "identifier13", latitude: 100, longitude: 100, name: "spot 13", imagePath: nil),
        .init(id: "identifier14", latitude: 100, longitude: 100, name: "spot 14", imagePath: nil),
        .init(id: "identifier15", latitude: 100, longitude: 100, name: "spot 15", imagePath: nil),
        .init(id: "identifier16", latitude: 100, longitude: 100, name: "spot 16", imagePath: nil),
        .init(id: "identifier17", latitude: 100, longitude: 100, name: "spot 17", imagePath: nil),
        .init(id: "identifier18", latitude: 100, longitude: 100, name: "spot 18", imagePath: nil),
        .init(id: "identifier19", latitude: 100, longitude: 100, name: "spot 19", imagePath: nil),
        .init(id: "identifier20", latitude: 100, longitude: 100, name: "spot 20", imagePath: nil),
        .init(id: "identifier21", latitude: 100, longitude: 100, name: "spot 21", imagePath: nil),
        .init(id: "identifier22", latitude: 100, longitude: 100, name: "spot 22", imagePath: nil),
        .init(id: "identifier23", latitude: 100, longitude: 100, name: "spot 23", imagePath: nil),
        .init(id: "identifier24", latitude: 100, longitude: 100, name: "spot 24", imagePath: nil),
        .init(id: "identifier25", latitude: 100, longitude: 100, name: "spot 25", imagePath: nil),
        .init(id: "identifier26", latitude: 100, longitude: 100, name: "spot 26", imagePath: nil),
        .init(id: "identifier27", latitude: 100, longitude: 100, name: "spot 27", imagePath: nil),
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
