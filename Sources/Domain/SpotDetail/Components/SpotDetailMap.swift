import Foundation
import SwiftUI
import MapKit

struct SpotDetailMap: View {
    let fragment: SpotDetailMapFragment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("スポット")
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
    }

    private var mapRect: MKMapRect {
        // NOTE: size: .init() means fitting to SwiftUI frame
        .init(origin: .init(.init(latitude: fragment.geoPoint.latitude, longitude: fragment.geoPoint.longitude)), size: .init())
    }
}

extension SpotDetailMapFragment: Identifiable {

}

