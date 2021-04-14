import Foundation

struct CloudStoragePathBuilder<Entity: CloudStorageImageFileName> {
    let initialFileName: String
    
    static func userSpot(userID: UserID, spotID: SpotID) -> CloudStoragePathBuilder<Spot> { .init(initialFileName: ["users", userID.rawValue, "spots", spotID.rawValue].joined(separator: "-")) }
}
