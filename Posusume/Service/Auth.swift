import Foundation
import FirebaseAuth

protocol AuthProtocol {
    func auth(closure: @escaping (Result<UserID, Swift.Error>) -> Void)
    func fetchUserID() -> UserID?
}

struct Auth: AuthProtocol {
    fileprivate init() { }

    func auth(closure: @escaping (Result<UserID, Swift.Error>) -> Void) {
        FirebaseAuth.Auth.auth().signInAnonymously() { (result, error) in
            if let error = error {
                closure(.failure(error))
                return
            }
            guard let result = result else {
                fatalError("unexpected pattern about result and error is nil")
            }
            let userID = UserID(rawValue: result.user.uid)!
            self.store(userID: userID)
            closure(.success(userID))
        }
    }
    
    private enum StoreKey {
        static let firebaseUserID: String = "firebaseUserID"
    }
    private func store(userID: UserID) {
        guard UserDefaults.standard.string(forKey: StoreKey.firebaseUserID) == nil else {
            return
        }
        UserDefaults.standard.setValue(userID.rawValue, forKey: StoreKey.firebaseUserID)
    }
    func fetchUserID() -> UserID? {
        guard let userID = UserDefaults.standard.string(forKey: StoreKey.firebaseUserID) else {
            return nil
        }
        return UserID(rawValue: userID)
    }
}

internal var auth: AuthProtocol = Auth()
