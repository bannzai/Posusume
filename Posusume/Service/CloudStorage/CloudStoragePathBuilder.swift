import Foundation

struct CloudStoragePathBuilder {
    let paths: [String]
    
    static func userSpot(userID: UserID, spotID: SpotID) -> CloudStoragePathBuilder { .init(paths: ["users", userID.rawValue, "spots", spotID.rawValue]) }
}
