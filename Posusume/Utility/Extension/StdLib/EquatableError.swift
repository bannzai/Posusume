import Foundation
import Combine

struct EquatableError: LocalizedError, Equatable {
    let error: Error
    var localizedDescription: String { error.localizedDescription }

    static func == (lhs: Self, rhs: Self) -> Bool {
        type(of: lhs) == type(of: rhs) && lhs.error._domain == rhs.error._domain && lhs.error._code == rhs.error._code && lhs.error.localizedDescription == rhs.error.localizedDescription
    }
}
