import Foundation
import FirebaseAuth
import Combine

protocol Auth {
    func auth() -> AnyPublisher<Me, Error>
}

fileprivate struct _Auth: Auth {
    init() { }

    func auth() -> AnyPublisher<Me, Error> {
        Future { promise in
            FirebaseAuth.Auth.auth().signInAnonymously() { (result, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let result = result else {
                    fatalError("unexpected pattern about result and error is nil")
                }
                let id = Me.ID(rawValue: result.user.uid)
                self.store(meID: id)
                promise(.success(Me(id: id)))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    private enum StoreKey {
        static let firebaseUserID: String = "firebaseUserID"
    }
    private func store(meID: Me.ID) {
        guard UserDefaults.standard.string(forKey: StoreKey.firebaseUserID) == nil else {
            return
        }
        UserDefaults.standard.setValue(meID.rawValue, forKey: StoreKey.firebaseUserID)
    }
}

internal var auth: Auth = _Auth()
