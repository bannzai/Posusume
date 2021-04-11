import Foundation
import FirebaseAuth
import Combine

protocol Auth {
    func auth() -> AnyPublisher<UserID, Error>
}

fileprivate struct _Auth: Auth {
    init() { }

    func auth() -> AnyPublisher<UserID, Error> {
        Future { promise in
            FirebaseAuth.Auth.auth().signInAnonymously() { (result, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let result = result else {
                    fatalError("unexpected pattern about result and error is nil")
                }
                let userID = UserID(rawValue: result.user.uid)!
                self.store(userID: userID)
                promise(.success(userID))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    private enum StoreKey {
        static let firebaseUserID: String = "firebaseUserID"
    }
    private func store(userID: UserID) {
        guard UserDefaults.standard.string(forKey: StoreKey.firebaseUserID) == nil else {
            return
        }
        UserDefaults.standard.setValue(userID.rawValue, forKey: StoreKey.firebaseUserID)
    }
}

internal var auth: Auth = _Auth()
