import SwiftUI

struct SpotListCell: View {
    let spot: Spot
    var body: some View {
        Image(uiImage: .init())
            .frame(width: 90, height: 120)
            .background(Color.red)
    }
}

struct SpotListCell_Previews: PreviewProvider {
    static var previews: some View {
        SpotListCell(spot: .init(id: nil, location: .init(latitude: 100, longitude: 100), title: "This is awesome spot", imageFileName: ""))
    }
}
