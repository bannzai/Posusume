import Foundation
import SwiftUI
import Apollo
import MapKit

struct SpotMapImage: View {
    let fragment: SpotMapImageFragment
    let mapView: MapKit.MKMapView

    @State var isPresentingSpotDetail: Bool = false

    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
        } placeholder: {
            ProgressView()
        }
                .onTapGesture {
                    // NOTE: AnnotationView should clear if want to enable touch again
                    mapView.selectedAnnotations.forEach {
                        mapView.deselectAnnotation($0, animated: false)
                    }

                    isPresentingSpotDetail = true
                }
                .sheet(isPresented: $isPresentingSpotDetail) {
                    SpotDetailPage(spotID: fragment.id)
                }
        .frame(width: 48, height: 48)
    }

    private var imageURL: URL {
        fragment.resizedSpotImageUrLs.thumbnail ?? fragment.imageUrl
    }
}
