import Foundation
import FirebaseFirestore

struct CollectionMapper<Entity: Decodable> {
    let snapshots: [DocumentSnapshot]

    var compacted: [Entity] { snapshots.compactMap { try? $0.data(as: Entity.self) }}
}

