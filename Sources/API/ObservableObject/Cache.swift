import Foundation
import Apollo

@MainActor
public final class Cache<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published public var data: Query.Data?

    public func retrieve(query: Query) async {
        do {
            data = try await AppApolloClient.shared.fetchFromCache(query: query)
        } catch {
            data = nil
        }
    }

    public func callAsFunction(query: Query) async {
        await retrieve(query: query)
    }
}
