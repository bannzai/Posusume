import Foundation

struct DatabaseDocumentPathBuilder<Entity: Codable> {
    let path: String
    
    static func userSpot(userID: UserID, spotID: SpotID) -> DatabaseDocumentPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots/\(spotID.rawValue)") }
}
struct DatabaseCollectionPathBuilder<Entity: DatabaseEntity> {
    let path: String
    var args: [(Entity.WhereKey, CollectionRelation)] = []
    var isGroup: Bool = false

    static func userSpots(userID: UserID) -> DatabaseCollectionPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots") }
    static func spotsGroup(args: [(Spot.WhereKey, CollectionRelation)]) -> DatabaseCollectionPathBuilder<Spot> { .init(path: "spots", args: args, isGroup: true) }
}

enum CollectionRelation {
    case equal(Any)
    case less(Any)
    case lessOrEqual(Any)
    case greater(Any)
    case greaterOrEqual(Any)
    case notEqual(Any)
    case contains([Any])
}