import Foundation
import SwiftUI
import FirebaseAuth
import CoreLocation

@MainActor
final class RootViewModel: ObservableObject {
    @Environment(\.locationManager) var locationManager
    @Environment(\.auth) var auth

    @Published var locationAuthorizationStatus: CLAuthorizationStatus?
    @Published var me: Me?

    var streamTask: Task<Void, Never>?

    func process() async throws {
        if case .requiredAutentification = locationManager.invalidationReason() {
            locationAuthorizationStatus = await locationManager.requestAuthorization()
        }
        me = try await signIn()

        streamTask?.cancel()
        streamTask = Task { @MainActor in
            for await user in auth.stateDidChange() {
                if let user = user {
                    self.me = .init(id: .init(rawValue: user.uid), isAnonymous: user.isAnonymous)
                } else {
                    self.me = nil
                }
            }
        }
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

    func signIn() async throws -> Me {
        let authentificatedUser = try await auth.signIn()

        let id = Me.ID(rawValue: authentificatedUser.uid)
        self.store(meID: id)

        return .init(id: id, isAnonymous: authentificatedUser.isAnonymous)
    }

    // MARK: - Private
    private enum StoreKey {
        static let firebaseUserID: String = "firebaseUserID"
    }
    // TODO: Use Keychain when production
    private func store(meID: Me.ID) {
        #if DEBUG
        guard UserDefaults.standard.string(forKey: StoreKey.firebaseUserID) == nil else {
            return
        }
        UserDefaults.standard.setValue(meID.rawValue, forKey: StoreKey.firebaseUserID)
        #endif
    }
}
