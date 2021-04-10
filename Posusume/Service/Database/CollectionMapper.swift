import Foundation
import FirebaseFirestore

struct CollectionMapper<Entity: Decodable> {
    let snapshots: [DocumentSnapshot]
    func mapped() throws -> [Entity] { try snapshots.map { try $0.data(as: Entity.self) }.compactMap { $0 }}
    func compacted() -> [Entity] { snapshots.compactMap { try? $0.data(as: Entity.self) }}
}

