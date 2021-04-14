import Foundation

protocol DatabaseEntity: Codable {
    associatedtype WhereKey: CodingKey & RawRepresentable where WhereKey.RawValue == String
}
