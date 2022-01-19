import Foundation


private let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
private let firestoreIDLength = UInt8(28)

/// generateDatabaseID is genrated firestore resource id
/// Like this: YA02PmZgP6dQynkrOglNsm6uu5u2
public func generateDatabaseID() -> String {
    String((0..<firestoreIDLength).map { _ in letters.randomElement()! })
}
