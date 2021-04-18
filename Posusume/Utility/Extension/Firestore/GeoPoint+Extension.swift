import Foundation
import FirebaseFirestore
import CoreLocation

private let latitudeOffset: CLLocationDegrees = 90
private let longitudeOffset: CLLocationDegrees = 180
extension GeoPoint {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
