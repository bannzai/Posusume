import Foundation
import SwiftUI

struct SpotMapImage: View {
    let fragment: SpotMapImageFragment

    var body: some View {
        AsyncImage(url: fragment.imageUrl) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 30, height: 40)
        .clipShape(Rectangle())
    }
}
