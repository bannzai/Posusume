import Foundation
import SwiftUI
import FirebaseAuth
import CoreLocation

@MainActor
final class RootViewModel: ObservableObject {
    @Environment(\.locationManager) var locationManager

    @Published var locationAuthorizationStatus: CLAuthorizationStatus?
    @Published var me: Me?

    func process() async throws {
        if case .requiredAutentification = locationManager.invalidationReason() {
            locationAuthorizationStatus = await locationManager.requestAuthorization()
        }
        me = try await signInAnonymously()
    }

    var viewKind: ViewKind {
        if let invalidationReason = locationManager.invalidationReason() {
            switch invalidationReason {
            case .requiredAutentification:
                return .waiting
            case .denied:
                return .requireLocationPermission
            }
        } else if let me = me {
            return .main(me: me)
        } else {
            return .waiting
        }
    }

    enum ViewKind {
        case waiting
        case requireLocationPermission
        case main(me: Me)
    }

    func signInAnonymously() async throws -> Me {
        try await withCheckedThrowingContinuation { continuation in
            FirebaseAuth.Auth.auth().signInAnonymously() { (result, error) in
                if let error = error {
                    continuation.resume(throwing: (mappedAppError(from: error)))
                    return
                } else {
                    guard let result = result else {
                        fatalError("unexpected pattern about result and error is nil")
                    }
                    let id = Me.ID(rawValue: result.user.uid)
                    self.store(meID: id)

                    let me = Me(id: id)
                    continuation.resume(returning: me)
                }
            }
        }
    }

    // MARK: - Private
    private enum StoreKey {
        static let firebaseUserID: String = "firebaseUserID"
    }
    // TODO: Use Keychain when production
    private func store(meID: Me.ID) {
        guard UserDefaults.standard.string(forKey: StoreKey.firebaseUserID) == nil else {
            return
        }
        UserDefaults.standard.setValue(meID.rawValue, forKey: StoreKey.firebaseUserID)
    }
}
