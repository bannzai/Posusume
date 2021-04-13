import Foundation

struct Me: Identifiable {
    let id: ID
    var userID: UserID { UserID(rawValue: id.rawValue) }

    struct ID: RawRepresentable, Equatable, Hashable {
        let rawValue: String
    }
}
