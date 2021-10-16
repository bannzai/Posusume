import Foundation
import SwiftUI

struct SpotMapImage: View {
    let fragment: SpotMapImageFragment

    @State var isPresentingSpotDetail: Bool = false

    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .overlay(Circle().stroke(GradientColor.barn, lineWidth: 1))
        .onTapGesture {
            isPresentingSpotDetail = true
        }
        .sheet(isPresented: $isPresentingSpotDetail) {
            SpotDetailPage(spotID: fragment.id)
        }
    }

    private var imageURL: URL {
        fragment.resizedSpotImageUrLs.thumbnail ?? fragment.imageUrl
    }
}
