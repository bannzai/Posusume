import Foundation

struct Me: Identifiable, Equatable {
    let id: ID

    struct ID: RawRepresentable, Equatable, Hashable {
        let rawValue: String
    }
}
