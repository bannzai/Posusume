import SwiftUI
import MapKit

@MainActor
final class SpotMapViewModel: ObservableObject {
    let cache = Cache<SpotsQuery>()
    let query = Query<SpotsQuery>()

    @Published var spots: [SpotsQuery.Data.Spot] = []
    @Published var error: Error?

    private var fetchedSpotRange: SpotRange? = nil

    func fetch(region: MKCoordinateRegion) {
        if cache.isFetching || query.isFetching {
            return
        }
        if !shouldFetchNewSpots(region: region) {
            return
        }

        Task {
            do {
                spots += await cache(for: .init(region: region))?.spots ?? []
                spots += try await query(for: .init(region: region)).spots
                updateFetchedSpotRange(region: region)
            } catch {
                self.error = error
            }
        }
    }

    private func shouldFetchNewSpots(region: MKCoordinateRegion) -> Bool {
        guard let fetchedSpotRange = fetchedSpotRange else {
            return true
        }
        return fetchedSpotRange.minLatitude > region.minLatitude ||
        fetchedSpotRange.minLongitude > region.minLongitude ||
        fetchedSpotRange.maxLatitude < region.maxLatitude ||
        fetchedSpotRange.maxLongitude < region.maxLongitude
    }

    private func updateFetchedSpotRange(region: MKCoordinateRegion) {
        let offsetLatitudeDelta: CLLocationDegrees = region.span.latitudeDelta / 2
        let offsetLongitudeDelta: CLLocationDegrees = region.span.longitudeDelta / 2

        if var fetchedSpotRange = fetchedSpotRange {
            if fetchedSpotRange.minLatitude > region.minLatitude {
                fetchedSpotRange.minLatitude = region.minLatitude - offsetLatitudeDelta
            }
            if fetchedSpotRange.minLongitude > region.minLongitude {
                fetchedSpotRange.minLongitude = region.minLongitude - offsetLongitudeDelta
            }
            if fetchedSpotRange.maxLatitude < region.maxLatitude {
                fetchedSpotRange.maxLatitude = region.maxLatitude + offsetLatitudeDelta
            }
            if fetchedSpotRange.maxLongitude < region.maxLongitude {
                fetchedSpotRange.maxLongitude = region.maxLongitude + offsetLongitudeDelta
            }

            self.fetchedSpotRange = fetchedSpotRange
        } else {
            fetchedSpotRange = .init(
                minLatitude: region.minLatitude - offsetLatitudeDelta,
                minLongitude: region.minLongitude - offsetLongitudeDelta,
                maxLatitude: region.maxLatitude + offsetLatitudeDelta,
                maxLongitude: region.maxLongitude + offsetLongitudeDelta
            )
        }
    }
}

extension SpotsQuery {
    convenience init(region: MKCoordinateRegion) {
        self.init(
            spotsMinLatitude: region.minLatitude,
            spotsMinLongitude: region.minLongitude,
            spotsMaxLatitude: region.maxLatitude,
            spotsMaxLongitude: region.maxLongitude
        )
    }
}

fileprivate struct SpotRange {
    var minLatitude: Latitude
    var minLongitude: Longitude
    var maxLatitude: Latitude
    var maxLongitude: Longitude

    func isOutOfRange(region: MKCoordinateRegion) -> Bool {
        return region.center.latitude < minLatitude ||
        region.center.latitude > maxLatitude ||
        region.center.longitude < minLongitude ||
        region.center.longitude > maxLongitude
    }
}

fileprivate extension Array where Element == SpotsQuery.Data.Spot {
    func spotRange() -> SpotRange? {
        guard let first = first else {
            return nil
        }
        let spotRange = SpotRange(minLatitude: first.geoPoint.latitude, minLongitude: first.geoPoint.longitude, maxLatitude: first.geoPoint.latitude, maxLongitude: first.geoPoint.longitude)
        return reduce(into: spotRange) { partialResult, spot in
            if partialResult.minLatitude > spot.geoPoint.latitude {
                partialResult.minLatitude = spot.geoPoint.latitude
            }
            if partialResult.maxLatitude < spot.geoPoint.latitude {
                partialResult.maxLatitude = spot.geoPoint.latitude
            }
            if partialResult.minLongitude > spot.geoPoint.longitude {
                partialResult.minLongitude = spot.geoPoint.longitude
            }
            if partialResult.maxLongitude < spot.geoPoint.longitude {
                partialResult.maxLongitude = spot.geoPoint.longitude
            }
        }
    }
}
