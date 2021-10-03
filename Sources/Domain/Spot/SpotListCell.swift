import SwiftUI

struct SpotListCell: View {
    var body: some View {
        Image(uiImage: .init())
            .frame(width: 90, height: 120)
            .background(Color.red)
    }
}

struct SpotListCell_Previews: PreviewProvider {
    static var previews: some View {
        SpotListCell()
    }
}
