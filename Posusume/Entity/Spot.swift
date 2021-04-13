import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct SpotID: RawRepresentable, Equatable, Codable, DocumentIDWrappable, Hashable {
    let rawValue: String
    
    static func wrap(_ documentReference: DocumentReference) throws -> SpotID {
        SpotID(rawValue: documentReference.documentID)
    }
}

struct Spot: DatabaseEntity, Identifiable, Equatable {
    @DocumentID var id: SpotID?
    let latitude: Double
    let longitude: Double
    let name: String
    var imagePath: String?
    private(set) var createdDate: Date = .init()
    var deletedDate: Date? = nil
    var archivedDate: Date? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case name
        case imagePath
        case createdDate
        case deletedDate
        case archivedDate
    }
    typealias WhereKey = CodingKeys
}

extension Spot: ImagePath { }
