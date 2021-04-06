import Foundation
import FirebaseAuth

protocol AuthProtocol {
    func auth(closure: @escaping (Result<Void, Swift.Error>) -> Void)
    func fetchUserID() -> String?
}

struct Auth: AuthProtocol {
    fileprivate init() { }
    
    func auth(closure: @escaping (Result<Void, Swift.Error>) -> Void) {
        FirebaseAuth.Auth.auth().signInAnonymously() { (result, error) in
            if let error = error {
                closure(.failure(error))
                return
            }
            guard let result = result else {
                fatalError("unexpected pattern about result and error is nil")
            }
            self.store(userID: result.user.uid)
            closure(.success(()))
        }
    }
    
    private enum StoreKey {
        static let firebaseUserID: String = "firebaseUserID"
    }
    private func store(userID: String) {
        guard UserDefaults.standard.string(forKey: StoreKey.firebaseUserID) == nil else {
            return
        }
        UserDefaults.standard.setValue(userID, forKey: StoreKey.firebaseUserID)
    }
    func fetchUserID() -> String? {
        UserDefaults.standard.string(forKey: StoreKey.firebaseUserID)
    }
}

internal var auth: AuthProtocol = Auth()
