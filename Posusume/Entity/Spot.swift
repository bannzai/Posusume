import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

enum SpotID: String, RawRepresentable, Codable, DocumentIDWrappable {
    case id
    
    static func wrap(_ documentReference: DocumentReference) throws -> SpotID {
        SpotID(rawValue: documentReference.documentID)!
    }
}

struct Spot: Identifiable {
    @DocumentID var id: SpotID?
    let latitude: Double
    let longitude: Double
    let name: String
    var imagePath: String?
    private(set) var createdDate: Date = .init()
    var deletedDate: Date? = nil
    var archivedDate: Date? = nil
}

extension Spot: ImagePath { }
