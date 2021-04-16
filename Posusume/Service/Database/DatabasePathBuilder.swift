import Foundation
import FirebaseFirestore

struct DatabaseDocumentPathBuilder<Entity: Codable> {
    let path: String
    
    static func userSpot(userID: UserID, spotID: SpotID) -> DatabaseDocumentPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots/\(spotID.rawValue)") }
}
struct DatabaseCollectionPathBuilder<Entity: DatabaseEntity> {
    let path: String
    var args: (key: Entity.WhereKey, relations: [CollectionRelation])? = nil
    var isGroup: Bool = false

    static func users() -> DatabaseCollectionPathBuilder<User> { .init(path: "/users") }
    static func userSpots(userID: UserID) -> DatabaseCollectionPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots") }
    static func spotsGroup(args: (key: Spot.WhereKey, relations: [CollectionRelation])) -> DatabaseCollectionPathBuilder<Spot> { .init(path: "spots", args: args, isGroup: true) }
}

enum CollectionRelation {
    case equal(Any)
    case less(Any)
    case lessOrEqual(Any)
    case greater(Any)
    case greaterOrEqual(Any)
    case notEqual(Any)
    case contains([Any])
    case geoRange(geoPoint: GeoPoint, distance: Double)
}
