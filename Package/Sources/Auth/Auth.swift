import Foundation
import FirebaseAuth
import SwiftUI
import AppError
import os.log

private let authLogger = Logger(subsystem: "com.posusume.log", category: "Auth")

public struct Auth {
    private var client: FirebaseAuth.Auth { .auth() }

    public typealias User = FirebaseAuth.User

    public static var firebaseCurrentUser: User? {
        FirebaseAuth.Auth.auth().currentUser
    }

    // MARK: - Stream
    public func stateDidChange() -> AsyncStream<User?> {
        .init { continuation in
            client.addStateDidChangeListener { auth, user in
                authLogger.debug("[DEBUG] auth state did changed. user is not nil: \(user != nil), user id \(String(describing: user?.uid))")
                continuation.yield(user)
            }
        }
    }

    // MARK: - SignIn
    public func signIn() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            if let user = client.currentUser {
                authLogger.debug("[DEBUG] SignIn: user is already exists")
                continuation.resume(returning: user)
            } else {
                client.signInAnonymously() { (result, error) in
                    if let error = error {
                        authLogger.debug("[DEBUG] SignIn: got error")
                        continuation.resume(throwing: (mappedAppError(from: error)))
                        return
                    } else {
                        guard let result = result else {
                            fatalError("unexpected pattern about result and error is nil")
                        }
                        authLogger.debug("[DEBUG] SignIn: SignIn: Done signin via signInAnonymously")
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
    public static var defaultValue: Auth = .init()
}

extension EnvironmentValues {
    public var auth: Auth {
        get {
            self[AuthClientKey.self]
        }
        set {
            self[AuthClientKey.self] = newValue
        }
    }
}
