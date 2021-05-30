import CoreLocation
import Combine

protocol Geocoder {
    func geocoder(address: String) -> AnyPublisher<[PlaceMark], Swift.Error>
    func reverseGeocoder(location: CLLocation) -> AnyPublisher<[PlaceMark], Error>
}

private struct _Geocoder: Geocoder {
    func geocoder(address: String) -> AnyPublisher<[PlaceMark], Error> {
        Future { promise in
            CLGeocoder().geocodeAddressString(address) { marks, error in
                if let error = error {
                    return promise(.failure(error))
                }
                promise(.success(map(marks)))
            }
        }.eraseToAnyPublisher()
    }

    func reverseGeocoder(location: CLLocation) -> AnyPublisher<[PlaceMark], Error> {
        Future { promise in
            CLGeocoder().reverseGeocodeLocation(location) { marks, error in
                if let error = error {
                    return promise(.failure(error))
                }
                promise(.success(map(marks)))
            }
        }.eraseToAnyPublisher()
    }
}

private func map(_ marks: [CLPlacemark]?) -> [PlaceMark] {
    (marks ?? []).compactMap { mark in
        guard let location = mark.location else {
            return nil
        }
        return PlaceMark(
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
    }
}

internal let geocoder: Geocoder = _Geocoder()

struct PlaceMark: Equatable, Identifiable {
    let id: UUID = .init()
    let name: String
    let country: String
    let postalCode: String
    let address: Address
    let location: CLLocationCoordinate2D

    struct Address: Equatable  {
        // 東京都
        let administrativeArea: String
        // 渋谷区
        let locality: String
        // X町 4丁目
        let thoroughfare: String
        // 1番1号
        let subThoroughfare: String

        var address: String {
            "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
        }
    }
}
