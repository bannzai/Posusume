import CoreLocation
import Combine

enum LocationManagerPrepareAction {
    case openSettingApp
    case requiredAutentification
}

protocol LocationManager: CLLocationManagerDelegate {
    func prepareActionType() -> LocationManagerPrepareAction?
    func requestAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never>
    func userLocation() -> AnyPublisher<CLLocation, Swift.Error>
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
    
    func prepareActionType() -> LocationManagerPrepareAction? {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            return .requiredAutentification
        case .denied:
            return .openSettingApp
        case .restricted:
            return .openSettingApp
        case .authorizedAlways:
            return nil
        case .authorizedWhenInUse:
            return nil
        @unknown default:
            assertionFailure("unexpected authorization status \(status):\(status.rawValue)")
            return nil
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

let locationManager: LocationManager = _LocationManager()
