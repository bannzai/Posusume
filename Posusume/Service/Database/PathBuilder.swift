import Foundation

struct DatabaseDocumentPathBuilder<Entity: Codable> {
    let path: String
    
    static func userSpot(userID: UserID, spotID: SpotID) -> DatabaseDocumentPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots/\(spotID.rawValue)") }
}
struct DatabaseCollectionPathBuilder<Entity: Codable> {
    let path: String

    static func userSpots(userID: UserID) -> DatabaseCollectionPathBuilder<Spot> { .init(path: "/users/\(userID.rawValue)/spots") }
}

