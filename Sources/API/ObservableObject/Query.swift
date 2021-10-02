import Foundation
import Apollo

@MainActor
public final class Query<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published public var isFetching: Bool = false
    @Published public var data: Query.Data?
    @Published public var error: Error?

    public func fetch(query: Query) async {
        isFetching = true
        defer {
            isFetching = false
        }

        do {
            data = try await AppApolloClient.shared.fetchFromServer(query: query)
        } catch {
            self.error = error
        }
    }

    public func callAsFunction(query: Query) async {
        await fetch(query: query)
    }
}
