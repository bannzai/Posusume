import Foundation
import CoreLocation
import MapKit

struct CoordinateSpan: Equatable {
    let latitudeDelta: CLLocationDegrees
    let longitudeDelta: CLLocationDegrees
    
    init(span: MKCoordinateSpan) {
        latitudeDelta = span.latitudeDelta
        longitudeDelta = span.longitudeDelta
    }
}

