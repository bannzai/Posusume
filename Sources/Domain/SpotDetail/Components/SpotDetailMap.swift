import Foundation
import SwiftUI
import MapKit

struct SpotDetailMap: View {
    @Environment(\.geocoder) var geocoder
    let fragment: SpotDetailMapFragment

    @State var placemark: Placemark?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placemark?.formattedLocationAddress() ?? "スポット")
                .font(.subheadline)

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
            placemark = try? await geocoder.reverseGeocode(location: .init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude)).first
        }
    }

    private var mapRect: MKMapRect {
        // NOTE: size: .init() means fitting to SwiftUI frame
        .init(origin: .init(.init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude)), size: .init())
    }
}

extension SpotDetailMapFragment: Identifiable {

}

