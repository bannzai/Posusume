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
///    await query(.init())
///  }
/// ```
@MainActor
public final class Query<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published public private(set) var isFetching = false
    @Published public private(set) var data: Query.Data?
    @Published public private(set) var error: Error?

    internal func fetch(query: Query) async {
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

    public func callAsFunction(_ query: Query) async {
        await fetch(query: query)
    }
}
