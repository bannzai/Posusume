import Foundation
import FirebaseAuth
import Combine

protocol Auth {
    var me: Me? { get }
    func signInAnonymously() -> AnyPublisher<Me, Error>
}

fileprivate class _Auth: Auth {
    var me: Me?
    init() { }
    
    func signInAnonymously() -> AnyPublisher<Me, Error> {
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

                let me = Me(id: id)
                self.me = me
                promise(.success(me))
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

private var _auth = _Auth()
internal var auth: Auth { _auth }
