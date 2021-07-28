import Foundation

struct User: Identifiable, Equatable {
    let id: UserID

    enum CodingKeys: String, CodingKey {
        case id
    }
}
