import CoreLocation
import Combine
import SwiftUI

public enum LocationManagerInvalidationReason {
    case requiredAutentification
    case denied
}

public protocol LocationManager: CLLocationManagerDelegate {
    func invalidationReason() -> LocationManagerInvalidationReason?
    func requestAuthorization() async -> CLAuthorizationStatus
    func userLocation() async throws -> CLLocation
}

private class _LocationManager: NSObject, LocationManager {
    var canceller: Set<AnyCancellable> = []
    let didChangeAuthorization: PassthroughSubject<CLAuthorizationStatus, Never> = .init()
    let userLocationSubject: PassthroughSubject<CLLocation, Swift.Error> = .init()
    let locationManager: CLLocationManager = .init()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.allowsBackgroundLocationUpdates = false
    }
    
    func invalidationReason() -> LocationManagerInvalidationReason? {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            return .requiredAutentification
        case .denied:
            return .denied
        case .restricted:
            return .denied
        case .authorizedAlways:
            return nil
        case .authorizedWhenInUse:
            return nil
        @unknown default:
            assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            return nil
        }
    }
    func requestAuthorization() async -> CLAuthorizationStatus {
        await withCheckedContinuation { continuation in
            requestAuthorization().sink { status in
                continuation.resume(returning: status)
            }
            .store(in: &canceller)
        }
    }
    func requestAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        Future { promise in
            self.didChangeAuthorization.sink { status in
                promise(.success(status))
            }
            .store(in: &self.canceller)

            self.locationManager.requestWhenInUseAuthorization()
        }.eraseToAnyPublisher()
    }
    func userLocation() async throws -> CLLocation {
        try await withCheckedThrowingContinuation { continuation in
            userLocation().sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }, receiveValue: {
                continuation.resume(returning: $0)
            }).store(in: &canceller)
        }
    }
    func userLocation() -> AnyPublisher<CLLocation, Swift.Error> {
        Future { promise in
            self.userLocationSubject.sink (receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case let .failure(error):
                    promise(.failure(error))
                }
            }, receiveValue: { location in
                promise(.success(location))
            }).store(in: &self.canceller)

            self.locationManager.requestLocation()
        }.eraseToAnyPublisher()
    }
}

extension _LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didChangeAuthorization.send(manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        userLocationSubject.send(completion: .failure(error))
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        userLocationSubject.send(location)
    }
}

public struct LocationManagerEnvironmentKey: EnvironmentKey {
    public static var defaultValue: LocationManager = _LocationManager()
}

extension EnvironmentValues {
    public var locationManager: LocationManager {
        get {
            self[LocationManagerEnvironmentKey.self]
        }
        set {
            self[LocationManagerEnvironmentKey.self] = newValue
        }
    }
}

