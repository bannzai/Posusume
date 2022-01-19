import Foundation
import MapKit

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && rhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension MKCoordinateRegion {
    var minLatitude: Latitude {
        convertIfLatitudeDegressReachedBoundary(center.latitude - span.latitudeDelta / 2)
    }
    var minLongitude: Longitude {
        convertIfLongitudeDegressReachedBoundary(center.longitude - span.longitudeDelta / 2)
    }
    var maxLatitude: Latitude {
        convertIfLatitudeDegressReachedBoundary(center.latitude + span.latitudeDelta / 2)
    }
    var maxLongitude: Longitude {
        convertIfLongitudeDegressReachedBoundary(center.longitude + span.longitudeDelta / 2)
    }

    var cornerDigresses: (topLeft: CLLocationCoordinate2D, topRight: CLLocationCoordinate2D, bottomLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) {
        (
            topLeft: .init(latitude: minLatitude, longitude: maxLongitude),
            topRight: .init(latitude: maxLatitude, longitude: maxLongitude),
            bottomLeft: .init(latitude: minLatitude, longitude: minLongitude),
            bottomRight: .init(latitude: maxLatitude, longitude: minLongitude)
        )
    }

    // NOTE: Latitude is between 90 ~ -90 degrees. Next to 90 is -89 degrees.
    // Since drawing range of Map UI is not repeated in the vertical direction, So, the maximum value is 90 and the minimum value is -90.
    // 90 degrees north and -90 degrees south
    private func convertIfLatitudeDegressReachedBoundary(_ latitude: CLLocationDegrees) -> CLLocationDegrees {
        min(90, max(-90, latitude))
    }

    // NOTE: Latitude is between 180 ~ -180 degrees. Next to 180 is -180 degrees.
    // 180 degrees east and -180 degrees west
    private func convertIfLongitudeDegressReachedBoundary(_ longitude: CLLocationDegrees) -> CLLocationDegrees {
        if longitude > 180 {
            let diff = longitude - 180
            return -180 + diff
        }
        if longitude < -180 {
            let diff = longitude + 180
            return 180 - diff
        }
        return longitude
    }
}
