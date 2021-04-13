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
    
    func fetch<T: Decodable>(path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error> {
        database.document(path.path).get()
    }
    func fetchList<T: Decodable>(path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<[T], Error> {
        Future { promise in
            let collectionReference = database.collection(path.path)
            path.args.forEach { key, relation in
                switch relation {
                case let .equal(value):
                    collectionReference.whereField(key.rawValue, isEqualTo: value)
                case let .less(value):
                    collectionReference.whereField(key.rawValue, isLessThan: value)
                case let .greater(value):
                    collectionReference.whereField(key.rawValue, isGreaterThan: value)
                case let .notEqual(value):
                    collectionReference.whereField(key.rawValue, isNotEqualTo: value)
                case let .contains(values):
                    collectionReference.whereField(key.rawValue, in: values)
                }
            }
            database.collection(path.path).getDocuments { (snapshot, error) in
                if let error = error {
                    return promise(.failure(error))
                }
                if let snapshot = snapshot {
                    do {
                        return promise(.success(try snapshot.documents.compactMap { try $0.data(as: T.self) }))
                    } catch {
                        promise(.failure(error))
                    }
                }
                return promise(.success([]))
            }
        }.eraseToAnyPublisher()
    }

    func create<T: Encodable>(value: T, path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<T, Error> {
        database.collection(path.path).add(value: value)
    }

    func update<T: Encodable>(value: T, path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error> {
        database.document(path.path).set(from: value)
    }
}
