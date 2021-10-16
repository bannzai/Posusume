import Foundation
import SwiftUI

struct SpotDetailImage: View {
    let width: CGFloat
    let fragment: SpotDetailImageFragment

    var body: some View {
        AsyncImage(url: fragment.imageUrl) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .spotImageFrame(width: width)
    }
}
