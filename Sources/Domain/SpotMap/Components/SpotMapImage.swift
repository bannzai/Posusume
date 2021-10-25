import Foundation
import SwiftUI
import Apollo

struct SpotMapImage: View {
    let fragment: SpotMapImageFragment

    @State var isPresentingSpotDetail: Bool = false

    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .onTapGesture {
                    isPresentingSpotDetail = true
                }
                .sheet(isPresented: $isPresentingSpotDetail) {
                    SpotDetailPage(spotID: fragment.id)
                }
        } placeholder: {
            ProgressView()
        }
        .frame(width: 40, height: 40)
    }

    private var imageURL: URL {
        fragment.resizedSpotImageUrLs.thumbnail ?? fragment.imageUrl
    }
}
