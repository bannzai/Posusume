import Foundation
import Firebase
import SwiftUI

public struct AuthClient {
    private var client: FirebaseAuth.Auth { .auth() }

    public typealias User = FirebaseAuth.User

    // MARK: - Stream
    public func stateDidChange() -> AsyncStream<User?> {
        .init { continuation in
            client.addStateDidChangeListener { auth, user in
                continuation.yield(user)
            }
        }
    }

    // MARK: - SignIn
    public func signIn() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            if let user = client.currentUser {
                continuation.resume(returning: user)
            } else {
                client.signInAnonymously() { (result, error) in
                    if let error = error {
                        continuation.resume(throwing: (mappedAppError(from: error)))
                        return
                    } else {
                        guard let result = result else {
                            fatalError("unexpected pattern about result and error is nil")
                        }
                        continuation.resume(returning: result.user)
                    }
                }
            }
        }
    }

    // MARK: - Link
    public enum LinkAccountType {
        case apple
        case twitter
    }
    public func link(for accountType: LinkAccountType) {

    }
}

public struct AuthClientKey: SwiftUI.EnvironmentKey {
    public static var defaultValue: AuthClient = .init()
}

extension EnvironmentValues {
    var auth: AuthClient {
        get {
            self[AuthClientKey.self]
        }
        set {
            self[AuthClientKey.self] = newValue
        }
    }
}
