import Foundation
import Apollo

public struct AppGraphQLError: Error {
    // Application error caused by server side application
    public let applicationErrors: [Apollo.GraphQLError]

    internal init(_ errors: [Apollo.GraphQLError]) {
        self.applicationErrors = errors
    }
}
