import Foundation
import Combine

@dynamicMemberLookup
struct EquatableError: Error, Equatable {
    let error: Error

    subscript<U>(dynamicMember keyPath: WritableKeyPath<Error, U>) -> U {
        return error[keyPath: keyPath]
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        type(of: lhs) == type(of: rhs) && lhs.error._domain == rhs.error._domain && lhs.error._code == rhs.error._code && lhs.error.localizedDescription == rhs.error.localizedDescription
    }
}
