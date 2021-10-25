import Foundation
import SwiftUI
import MapKit

struct SpotDetailMap: View {
    @Environment(\.geocoder) var geocoder
    let fragment: SpotDetailMapFragment

    @State var locationName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(locationName ?? "スポット")
                .font(.title)

            Map(
                mapRect: .constant(mapRect),
                annotationItems: [fragment],
                annotationContent: { fragment in
                    MapPin(coordinate: .init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude))
                })
                .frame(maxWidth: .infinity, idealHeight: 200)
                .cornerRadius(4.0)
        }
        .task {
            locationName = try? await geocoder.reverseGeocode(location: .init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude)).first?.formattedLocationAddress()
        }
    }

    private var mapRect: MKMapRect {
        // NOTE: size: .init() means fitting to SwiftUI frame
        .init(origin: .init(.init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude)), size: .init())
    }
}

extension SpotDetailMapFragment: Identifiable {

}

