import Foundation
import CoreLocation

struct CoordinateSpan: Equatable {
    let latitudeDelta: CLLocationDegrees
    let longitudeDelta: CLLocationDegrees
}

