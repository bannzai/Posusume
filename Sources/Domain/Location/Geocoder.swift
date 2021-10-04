import CoreLocation
import Combine
import SwiftUI

public protocol Geocoder {
    func geocode(address: String) async throws -> [Place]
}

private struct _Geocoder: Geocoder {
    func geocode(address: String) async throws -> [Place] {
        try await withCheckedThrowingContinuation { continuation in
            CLGeocoder().geocodeAddressString(address) { marks, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }


                continuation.resume(returning: (marks ?? []).compactMap { mark in
                    guard let location = mark.location else {
                        return nil
                    }
                    return Place(
                        name: mark.name ?? "",
                        country: mark.country ?? "",
                        postalCode: mark.postalCode ?? "",
                        address: .init(
                            administrativeArea: mark.administrativeArea ?? "",
                            locality: mark.locality ?? "",
                            thoroughfare: mark.thoroughfare ?? "",
                            subThoroughfare: mark.subThoroughfare ?? ""
                        ),
                        location: location.coordinate
                    )
                })
            }
        }
    }
}

public struct Place: Equatable, Identifiable {
    public let id: UUID = .init()
    public let name: String
    public let country: String
    public let postalCode: String
    public let address: Address
    public let location: CLLocationCoordinate2D

    public struct Address: Equatable  {
        // 東京都
        public let administrativeArea: String
        // 渋谷区
        public let locality: String
        // X町 4丁目
        public let thoroughfare: String
        // 1番1号
        public let subThoroughfare: String

        public var address: String {
            "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
        }
    }

    func formattedLocationAddress() -> String {
        if !name.isEmpty {
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

