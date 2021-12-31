import Foundation
import MapKit

final class SpotAnnotation: NSObject, MKAnnotation {
    typealias Spot = SpotQuery.Data.Spot

    let spot: Spot
    var coordinate: CLLocationCoordinate2D { .init(latitude: spot.geoPoint.latitude, longitude: spot.geoPoint.longitude) }

    init(spot: Spot) {
        self.spot = spot
    }
}

