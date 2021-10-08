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
        .frame(width: 40, height: 40)
        .clipShape(Circle())
    }
}
