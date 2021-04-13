import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

extension DocumentReference {
    // MARK: - Get
    enum GetDocumentError: Error {
        case snapshotIsNotFound
        case snapshotDecodeFailure
    }
    func get<T: Decodable>() -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            self?.getDocument(source: .default, completion: { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                }
                guard let snapshot = snapshot else {
                    return promise(.failure(GetDocumentError.snapshotIsNotFound))
                }
                
                do {
                    guard let decoded = try snapshot.data(as: T.self) else {
                        return promise(.failure(GetDocumentError.snapshotDecodeFailure))
                    }
                    promise(.success(decoded))
                } catch {
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    
    // MARK: - Set
    func set<T: Encodable>(from value: T) -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            do {
                try self?.setData(from: value, merge: true, encoder: Firestore.Encoder()) { error in
                    guard let error = error else {
                        promise(.success(value))
                        return
                    }
                    promise(.failure(error))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

