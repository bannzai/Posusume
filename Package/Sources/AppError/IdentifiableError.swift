import Foundation
import Combine

public struct IdentifiableError: LocalizedError, Identifiable {
    internal let error: Error
    public init(_ error: Error) {
        self.error = error
    }

    public var id: AnyHashable {
        "\(error._domain)\(error._code)"
    }
    public var localizedDescription: String {
        if let graphQLError = error as? AppGraphQLError {
            if let firstError = graphQLError.applicationErrors.first {
                return firstError.localizedDescription
            } else {
                return graphQLError.localizedDescription
            }
        } else {
            return error.localizedDescription
        }
    }
}
