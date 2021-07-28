import Foundation
import CoreLocation

struct Spot: Identifiable, CloudStorageImageFileName, Equatable {
    let id: String
    var location: GeoPoint
    var title: String
    var imageFileName: String
    private(set) var createdDate: Date = .init()
    var deletedDate: Date? = nil
    var archivedDate: Date? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case location
        case title
        case imageFileName
        case createdDate
        case deletedDate
        case archivedDate
        
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: location.latitude, longitude: location.longitude)
    }
}
