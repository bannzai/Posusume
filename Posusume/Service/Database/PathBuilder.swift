import Foundation

struct DatabaseDocumentPathBuilder<Entity: Codable> {
    let path: String
    
    static func userSpot(userID: UserID, spotID: SpotID) -> DatabaseDocumentPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots/\(spotID.rawValue)") }
}
struct DatabaseCollectionPathBuilder<Entity: ExplicitKeyCodable> {
    let path: String
    var args: [(Entity.WhereKey, CollectionRelation)] = []

    static func userSpots(userID: UserID) -> DatabaseCollectionPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots") }
    static func spots(args: [(Spot.WhereKey, CollectionRelation)]) -> DatabaseCollectionPathBuilder<Spot> { .init(path: "/spots", args: args) }
}

enum CollectionRelation {
    case equal(Any)
    case less(Any)
    case greater(Any)
    case notEqual(Any)
    case contains([Any])
}
