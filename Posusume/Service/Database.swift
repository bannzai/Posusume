import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

protocol Database {
    func fetch<T: Decodable>(path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error>
    func fetchList<T: Decodable>(path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<[T], Error>
    func createOrUpdate<T: Encodable>(path: DatabaseCollectionPathBuilder<T>, value: T, identifier: String?) -> AnyPublisher<T, Error>
    func update<T: Encodable>(path: DatabaseDocumentPathBuilder<T>, value: T) -> AnyPublisher<T, Error>
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
            buildCollectionQuery(for: path).getDocuments { (snapshot, error) in
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
                errors.forEach { print("cause decode error when fetch list for \(path). error description \($0)") }
                return promise(.success(entities))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Watch
    func watchList<T: Decodable>(path: DatabaseCollectionPathBuilder<T>) -> AnyPublisher<[T], Error>{
        let subject = PassthroughSubject<[T], Error>()
        buildCollectionQuery(for: path).addSnapshotListener { (snapshot, error) in
            if let error = error {
                return subject.send(completion: .failure(error))
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
            errors.forEach { print("cause decode error when watch list for \(path). error description \($0)") }
            return subject.send(entities)
        }
        return subject.eraseToAnyPublisher()
    }

    // MARK: - Modifier
    func createOrUpdate<T: Encodable>(path: DatabaseCollectionPathBuilder<T>, value: T, identifier: String?) -> AnyPublisher<T, Error> {
        switch identifier {
        case nil:
            return database.collection(path.path).document().set(from: value)
        case let identifier?:
            return database.collection(path.path).document(identifier).set(from: value)
        }
    }

    func update<T: Encodable>(path: DatabaseDocumentPathBuilder<T>, value: T) -> AnyPublisher<T, Error> {
        database.document(path.path).set(from: value)
    }
}

// MARK: - Private
private extension FirestoreDatabase {
    func buildCollectionQuery<T: Decodable>(for path: DatabaseCollectionPathBuilder<T>) -> FirebaseFirestore.Query {
        var query = path.isGroup ? database.collectionGroup(path.path) : database.collection(path.path)
        if let args = path.args {
            args.relations.forEach { relation in
                switch relation {
                case let .equal(value):
                    query = query.whereField(args.key.rawValue, isEqualTo: value)
                case let .less(value):
                    query = query.whereField(args.key.rawValue, isLessThan: value)
                case let .lessOrEqual(value):
                    query = query.whereField(args.key.rawValue, isLessThanOrEqualTo: value)
                case let .greater(value):
                    query = query.whereField(args.key.rawValue, isGreaterThan: value)
                case let .greaterOrEqual(value):
                    query = query.whereField(args.key.rawValue, isGreaterThanOrEqualTo: value)
                case let .notEqual(value):
                    query = query.whereField(args.key.rawValue, isNotEqualTo: value)
                case let .contains(values):
                    query = query.whereField(args.key.rawValue, in: values)
                case let .geoRange(geoPoint, distance):
                    query = buildGeoQuery(
                        query: query,
                        key: args.key.rawValue,
                        baseGeoPoint: geoPoint,
                        distance: distance
                    )
                }
            }
        }
        return query
    }

    // NOTE: Reference https://stackoverflow.com/questions/46630507/how-to-run-a-geo-nearby-query-with-firestore
    private var mileDigress: CLLocationCoordinate2D {
        .init(
            latitude: 0.0144927536231884,
            longitude: 0.0181818181818182
        )
    }
    private func buildGeoQuery(
        query: FirebaseFirestore.Query,
        key: String,
        baseGeoPoint geoPoint: GeoPoint,
        distance: Double
    ) -> FirebaseFirestore.Query {
        let lowerLat = geoPoint.latitude - (mileDigress.latitude * distance)
        let lowerLon = geoPoint.longitude - (mileDigress.longitude * distance)
        
        let greaterLat = geoPoint.latitude + (mileDigress.latitude * distance)
        let greaterLon = geoPoint.longitude + (mileDigress.longitude * distance)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        
        return query.whereField(key, isGreaterThan: lesserGeopoint).whereField(key, isLessThan: greaterGeopoint)
    }
}
