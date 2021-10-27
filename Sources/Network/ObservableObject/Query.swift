import Foundation
import Apollo

/// Query fetch data from server with `GraphQL Query` and published data
///
/// Declare
/// ```swift
///  @StateObject var query = Query<PosusumeQuery>()
/// ```
///
/// Call query in task
/// ```swift
///  .task {
///    await query(for: PosusumeQuery())
///  }
/// ```
@MainActor
public final class Query<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published public private(set) var isFetching = false

    internal func fetch(query: Query) async throws -> Query.Data {
        isFetching = true
        defer {
            isFetching = false
        }

        return try await AppApolloClient.shared.fetchFromServer(query: query)
    }

    public func callAsFunction(for query: Query) async throws -> Query.Data {
        try await fetch(query: query)
    }
}
