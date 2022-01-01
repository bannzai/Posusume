import Foundation
import SwiftUI
import Apollo
import MapKit

struct SpotMapImage: View {
    let fragment: SpotMapImageFragment

    @State var isPresentingSpotDetail: Bool = false

    var body: some View {
        let _ = Self._printChanges()
        AsyncImageView(url: imageURL) { image in
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

    fileprivate var imageURL: URL {
        fragment.resizedSpotImageUrLs.thumbnail ?? fragment.imageUrl
    }
}


extension SpotMapImage: Equatable {
    static func ==(lhs: SpotMapImage, rhs: SpotMapImage) -> Bool {
        lhs.imageURL == rhs.imageURL
    }
}

extension SpotMapImageFragment: Identifiable { }
