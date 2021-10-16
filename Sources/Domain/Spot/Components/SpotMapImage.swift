import Foundation
import SwiftUI

struct SpotMapImage: View {
    let fragment: SpotMapImageFragment

    var body: some View {
        NavigationLink(
            destination: {
                SpotDetailPage()
            },
            label: {
                AsyncImage(url: fragment.resizedSpotImageUrLs.thumbnail ?? fragment.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(GradientColor.barn, lineWidth: 1))
            }
        )
    }
}
