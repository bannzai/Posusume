import CoreLocation
import Combine
import SwiftUI

public protocol Geocoder {
    func geocode(address: String) async throws -> [Placemark]
    func reverseGeocode(location: CLLocation) async throws -> [Placemark]
}



extension CLGeocoder: Geocoder {
    public func geocode(address: String) async throws -> [Placemark] {
        try await geocodeAddressString(address).map(Placemark.init)
    }
    public func reverseGeocode(location: CLLocation) async throws -> [Placemark] {
        try await reverseGeocodeLocation(location).map(Placemark.init)
    }
}

public struct GeocoderEnvironmentKey: EnvironmentKey {
    public static var defaultValue: Geocoder = CLGeocoder()
}

extension EnvironmentValues {
    public var geocoder: Geocoder {
        get {
            self[GeocoderEnvironmentKey.self]
        }
        set {
            self[GeocoderEnvironmentKey.self] = newValue
        }
    }
}

@dynamicMemberLookup public struct Placemark: Identifiable {
    public let id = UUID()
    internal let placemark: CLPlacemark

    // NOTE: location is not nil when instantiate through from geocoder methods
    // https://developer.apple.com/documentation/corelocation/clplacemark
    public var location: CLLocation {
        placemark.location!
    }

    public init(placemark: CLPlacemark) {
        self.placemark = placemark
    }

    public subscript<U>(dynamicMember keyPath: KeyPath<CLPlacemark, U>) -> U {
        return placemark[keyPath: keyPath]
    }

    public func formattedLocationAddress() -> String {
        if let name = placemark.name, !name.isEmpty, !placemark.address.contains(name) {
            return "\(name) \(placemark.address)"
        }
        return placemark.address
    }
}


extension CLPlacemark {
    // 東京都渋谷区X町 4丁目1番1号
    public var address: String {
        [administrativeArea, locality, thoroughfare, subThoroughfare]
            .compactMap{ $0 }
            .joined()
    }
}
