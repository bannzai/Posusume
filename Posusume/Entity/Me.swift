import Foundation

struct Me: Identifiable, Equatable {
    let id: ID
    var userID: UserID { UserID(rawValue: id.rawValue) }

    struct ID: RawRepresentable, Equatable, Hashable {
        let rawValue: String
    }
}
