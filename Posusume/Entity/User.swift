import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserID: RawRepresentable, Codable, DocumentIDWrappable, Hashable {
    let rawValue: String
    
    static func wrap(_ documentReference: DocumentReference) throws -> UserID {
        UserID(rawValue: documentReference.documentID)
    }
}

struct User: DatabaseEntity, Equatable, Identifiable {
    @DocumentID var id: UserID?
    let anonymousUserID: UserID

    enum CodingKeys: String, CodingKey {
        case anonymousUserID
    }
    typealias WhereKey = CodingKeys
}
