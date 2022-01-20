import Foundation
import SwiftUI
import GraphQL
import Components

struct SpotDetailImage: View {
    let width: CGFloat
    let fragment: SpotDetailImageFragment

    var body: some View {
        CachedAsyncImage(url: fragment.imageUrl) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .spotImageFrame(width: width)
    }
}

