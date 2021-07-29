import SwiftUI
import Combine

struct SpotList: View {
    typealias Cell = SpotListCell

    var body: some View {
        EmptyView()
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack {
//                ForEach(state.spots) { spot in
//                    Cell(spot: spot)
//                }
//            }
//        }
    }
}

struct SpotList_Previews: PreviewProvider {
    static var previews: some View {
        SpotList()
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 300))
    }
}
