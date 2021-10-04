import CoreLocation
import Combine
import SwiftUI

public protocol Geocoder {
    func geocode(address: String) async throws -> [Placemark]
}

private struct _Geocoder: Geocoder {
    func geocode(address: String) async throws -> [Placemark] {
        try await CLGeocoder()
            .geocodeAddressString(address)
            .compactMap { mark in
                guard let location = mark.location else {
                    return nil
                }
                return Placemark(
                    name: mark.name,
                    country: mark.country,
                    isoCountryCode: mark.isoCountryCode,
                    postalCode: mark.postalCode,
                    inlandWater: mark.inlandWater,
                    ocean: mark.ocean,
                    areasOfInterest: mark.areasOfInterest,
                    address: .init(
                        administrativeArea: mark.administrativeArea,
                        subAdministrativeArea: mark.subAdministrativeArea,
                        locality: mark.locality,
                        subLocality: mark.subLocality,
                        thoroughfare: mark.thoroughfare,
                        subThoroughfare: mark.subThoroughfare
                    ),
                location: location.coordinate
            )
        }
    }
}

public struct Placemark: Equatable, Identifiable {
    public let id: UUID = .init()
    public let name: String?
    public let country: String?
    public let isoCountryCode: String?
    public let postalCode: String?
    public let inlandWater: String?
    public let ocean: String?
    public let areasOfInterest: [String]?
    public let address: Address
    public let location: CLLocationCoordinate2D

    public struct Address: Equatable  {
        // 東京都
        public let administrativeArea: String?

        public let subAdministrativeArea: String?

        // 渋谷区
        public let locality: String?

        // neighborhood, common name, eg. Mission District
        public let subLocality: String?

        // X町 4丁目
        public let thoroughfare: String?
        // 1番1号
        public let subThoroughfare: String?

        // 東京都渋谷区X町 4丁目1番1号
        public var address: String {
            [administrativeArea, locality, thoroughfare, subThoroughfare]
                .compactMap{ $0 }
                .joined()
        }
    }

    func formattedLocationAddress() -> String {
        if let name = name, !name.isEmpty, !address.address.contains(name) {
            return "\(name): \(address.address)"
        }
        return address.address
    }
}

public struct GeocoderEnvironmentKey: EnvironmentKey {
    public static var defaultValue: Geocoder = _Geocoder()
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

