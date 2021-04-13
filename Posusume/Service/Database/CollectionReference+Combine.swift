import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

extension CollectionReference {
    // MARK: - Add
    func add<T: Encodable>(value: T) -> AnyPublisher<T, Error> {
        return Future { [weak self] promise in
            do {
                _ = try self?.addDocument(from: value, encoder: Firestore.Encoder()) { error in
                    if let error = error {
                        promise(.failure(error))
                    }
                    promise(.success(value))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

