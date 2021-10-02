import Foundation
import Apollo

public final class Cache<Query: Apollo.GraphQLQuery>: ObservableObject {
    public func retrieve(query: Query) async throws -> Query.Data? {
        return try await AppApolloClient.shared.fetchFromCache(query: query)
    }

    public func callAsFunction(query: Query) async throws -> Query.Data? {
        try await retrieve(query: query)
    }
}

