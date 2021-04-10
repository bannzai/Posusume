import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum UserID: String, RawRepresentable, Codable, DocumentIDWrappable {
    case id
    
    static func wrap(_ documentReference: DocumentReference) throws -> UserID {
        UserID(rawValue: documentReference.documentID)!
    }
}

struct User: Codable, Identifiable {
    @DocumentID var id: UserID?
    let anonymouseUserID: UserID
}
