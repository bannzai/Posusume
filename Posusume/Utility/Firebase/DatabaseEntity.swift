import Foundation

protocol DatabaseEntity: Codable {
    associatedtype WhereKey: CodingKey & Hashable & RawRepresentable where WhereKey.RawValue == String
}
