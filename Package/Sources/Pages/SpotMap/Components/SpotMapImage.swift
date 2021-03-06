import Foundation
import SwiftUI
import MapKit
import Components
import GraphQL
import SpotDetail

struct SpotMapImage: View {
    let fragment: SpotMapImageFragment

    @State var isPresentingSpotDetail: Bool = false

    var body: some View {
        let _ = Self._printChanges()
        CachedAsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .onTapGesture {
                    isPresentingSpotDetail = true
                }
                .sheet(isPresented: $isPresentingSpotDetail) {
                    NavigationView {
                        SpotDetailPage(spotID: fragment.id)
                    }
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
