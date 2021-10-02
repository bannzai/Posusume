import Foundation
import Apollo

public final class Cache<Query: Apollo.GraphQLQuery>: ObservableObject {
    public func fetch(query: Query) async throws -> Query.Data? {
        try await AppApolloClient.shared.fetchFromCache(query: query)
    }

    public func callAsFunction(query: Query) async throws -> Query.Data? {
        try await fetch(query: query)
    }
}

