import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserID: RawRepresentable, Codable, DocumentIDWrappable, Hashable {
    let rawValue: String
    
    static func wrap(_ documentReference: DocumentReference) throws -> UserID {
        UserID(rawValue: documentReference.documentID)
    }
}

struct User: Codable, Identifiable {
    @DocumentID var id: UserID?
    let anonymouseUserID: UserID
}
