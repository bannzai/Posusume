import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import CoreLocation

struct SpotID: RawRepresentable, Equatable, Codable, DocumentIDWrappable, Hashable {
    let rawValue: String
    
    static func wrap(_ documentReference: DocumentReference) throws -> SpotID {
        SpotID(rawValue: documentReference.documentID)
    }
}

struct Spot: DatabaseEntity, CloudStorageImageFileName, Identifiable, Equatable {
    @DocumentID var id: SpotID?
    var location: GeoPoint
    var title: String
    var imageFileName: String
    private(set) var createdDate: Date = .init()
    var deletedDate: Date? = nil
    var archivedDate: Date? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case location
        case title
        case imageFileName
        case createdDate
        case deletedDate
        case archivedDate
        
    }
    typealias WhereKey = CodingKeys
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: location.latitude, longitude: location.longitude)
    }
}
