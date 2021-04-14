import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Database {
    func fetch<T: Decodable>(path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error>
    func fetchList<T: Decodable>(path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<[T], Error>
    func create<T: Encodable>(value: T, path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<T, Error>
    func update<T: Encodable>(value: T, path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error>
}

private let database = Firestore.firestore()
struct FirestoreDatabase: Database {
    static let shared = FirestoreDatabase()
    private init() { }
    
    // MARK: - Fetch
    func fetch<T: Decodable>(path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error> {
        database.document(path.path).get()
    }
    
    struct DecodeError {
        let index: Int
        let error: Error
        let data: [String: Any]
    }
    func fetchList<T: Decodable>(path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<[T], Error> {
        Future { promise in
            let collectionReference = path.isGroup ? database.collectionGroup(path.path) : database.collection(path.path)
            path.args.forEach { key, relation in
                switch relation {
                case let .equal(value):
                    collectionReference.whereField(key.rawValue, isEqualTo: value)
                case let .less(value):
                    collectionReference.whereField(key.rawValue, isLessThan: value)
                case let .lessOrEqual(value):
                    collectionReference.whereField(key.rawValue, isLessThanOrEqualTo: value)
                case let .greater(value):
                    collectionReference.whereField(key.rawValue, isGreaterThan: value)
                case let .greaterOrEqual(value):
                    collectionReference.whereField(key.rawValue, isGreaterThanOrEqualTo: value)
                case let .notEqual(value):
                    collectionReference.whereField(key.rawValue, isNotEqualTo: value)
                case let .contains(values):
                    collectionReference.whereField(key.rawValue, in: values)
                }
            }
            collectionReference.getDocuments { (snapshot, error) in
                if let error = error {
                    return promise(.failure(error))
                }
                
                var entities: [T] = []
                var errors: [DecodeError] = []
                if let snapshot = snapshot {
                    snapshot.documents.enumerated().forEach { offset, document in
                        do {
                            try document.data(as: T.self).map {
                                entities.append($0)
                            }
                        } catch {
                            errors.append(.init(index: offset, error: error, data: document.data()))
                        }
                    }
                }
                errors.forEach { print("cause error when fetch list for \(path). error description \($0)") }
                return promise(.success(entities))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Watch
    func watchList<T: Decodable>(path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<[T], Error>{
        fatalError("TODO:")
    }

    // MARK: - Modifier
    func create<T: Encodable>(value: T, path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<T, Error> {
        database.collection(path.path).add(value: value)
    }

    func update<T: Encodable>(value: T, path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error> {
        database.document(path.path).set(from: value)
    }
}
