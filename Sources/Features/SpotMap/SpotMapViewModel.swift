import SwiftUI
import MapKit

@MainActor
final class SpotMapViewModel: ObservableObject {
    let cache = Cache<SpotsQuery>()
    let query = Query<SpotsQuery>()

    @Published var spots: [SpotsQuery.Data.Spot] = []
    @Published var error: Error?

    private var fetchedSpotCoordinateRange: SpotCoordinateRange? = nil

    func fetch(region: MKCoordinateRegion) {
        if cache.isFetching || query.isFetching {
            return
        }
        if !shouldFetchNewSpots(region: region) {
            return
        }
        updateFetchedSpotCoordinateRange(region: region)

        Task {
            do {
                spots += await cache(for: .init(region: region))?.spots ?? []
                spots += try await query(for: .init(region: region)).spots
            } catch {
                self.error = error
            }
        }
    }

    private func shouldFetchNewSpots(region: MKCoordinateRegion) -> Bool {
        guard let spotCoordinateRange = fetchedSpotCoordinateRange else {
            return true
        }
        let offsetLatitudeDelta: CLLocationDegrees = region.span.latitudeDelta / 2
        let offsetLongitudeDelta: CLLocationDegrees = region.span.longitudeDelta / 2

        return spotCoordinateRange.minLatitude > region.minLatitude + offsetLatitudeDelta ||
        spotCoordinateRange.minLongitude > region.minLongitude + offsetLongitudeDelta ||
        spotCoordinateRange.maxLatitude < region.maxLatitude - offsetLatitudeDelta ||
        spotCoordinateRange.maxLongitude < region.maxLongitude - offsetLongitudeDelta
    }

    private func updateFetchedSpotCoordinateRange(region: MKCoordinateRegion) {
        let offsetLatitudeDelta: CLLocationDegrees = region.span.latitudeDelta / 2
        let offsetLongitudeDelta: CLLocationDegrees = region.span.longitudeDelta / 2

        if var spotCoordinateRange = fetchedSpotCoordinateRange {
            if spotCoordinateRange.minLatitude > region.minLatitude + offsetLatitudeDelta {
                spotCoordinateRange.minLatitude = region.minLatitude
            }
            if spotCoordinateRange.maxLatitude < region.maxLatitude - offsetLatitudeDelta {
                spotCoordinateRange.maxLatitude = region.maxLatitude
            }
            if spotCoordinateRange.minLongitude > region.minLongitude + offsetLongitudeDelta {
                spotCoordinateRange.minLongitude = region.minLongitude
            }
            if spotCoordinateRange.maxLongitude < region.maxLongitude - offsetLongitudeDelta {
                spotCoordinateRange.maxLongitude = region.maxLongitude
            }

            self.fetchedSpotCoordinateRange = spotCoordinateRange
        } else {
            fetchedSpotCoordinateRange = .init(
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

fileprivate struct SpotCoordinateRange {
    var minLatitude: Latitude
    var minLongitude: Longitude
    var maxLatitude: Latitude
    var maxLongitude: Longitude
}

fileprivate extension Array where Element == SpotsQuery.Data.Spot {
    func spotRange() -> SpotCoordinateRange? {
        guard let first = first else {
            return nil
        }
        let spotRange = SpotCoordinateRange(minLatitude: first.geoPoint.latitude, minLongitude: first.geoPoint.longitude, maxLatitude: first.geoPoint.latitude, maxLongitude: first.geoPoint.longitude)
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
