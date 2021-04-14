import Foundation

struct CloudStoragePathBuilder<Entity: CloudStorageImageFileName> {
    let paths: [String]
    
    static func userSpot(userID: UserID, spotID: SpotID) -> CloudStoragePathBuilder<Spot> { .init(paths: ["users", userID.rawValue, "spots", spotID.rawValue]) }
}
