import Foundation
import SwiftUI
import MapKit

struct SpotDetailMap: View {
    let response: SpotQuery.Data

    var body: some View {
        VStack(spacing: 10) {
            Text("スポット").font(.subheadline)

            Map(mapRect: .constant(mapRect),
                annotationItems: [response.spot],
                annotationContent: { spot in
                MapPin(coordinate: .init(latitude: spot.geoPoint.latitude, longitude: spot.geoPoint.longitude))
            }).frame(maxWidth: .infinity, idealHeight: 200)
        }
    }

    private var mapRect: MKMapRect {
        // NOTE: size: .init() means fitting to SwiftUI frame
        .init(origin: .init(.init(latitude: response.spot.geoPoint.latitude, longitude: response.spot.geoPoint.longitude)), size: .init())
    }
}
