import CoreLocation
import Combine
import SwiftUI

public protocol Geocoder {
    func geocode(address: String) async throws -> [CLPlacemark]
    func reverseGeocode(location: CLLocation) async throws -> [CLPlacemark]
}



extension CLGeocoder: Geocoder {
    public func geocode(address: String) async throws -> [CLPlacemark] {
        try await geocodeAddressString(address)
    }
    public func reverseGeocode(location: CLLocation) async throws -> [CLPlacemark] {
        try await reverseGeocodeLocation(location)
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



extension CLPlacemark {
    // 東京都渋谷区X町 4丁目1番1号
    public var address: String {
        [administrativeArea, locality, thoroughfare, subThoroughfare]
            .compactMap{ $0 }
            .joined()
    }

    public func formattedLocationAddress() -> String {
        if let name = name, !name.isEmpty, !address.contains(name) {
            return "\(name) \(address)"
        }
        return address
    }
}
