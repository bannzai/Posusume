import Foundation
import Apollo

/// Cache retrieve data from local storage with `GraphQL Query` and published data
///
/// Cache published exists data or nil
/// If caused any error when retrieving data from local stroage client, ignore error and set data to nil
/// In most cases data will be fetched from the server  via query after `cache`.
///
/// Declare
/// ```swift
///  @StateObject var cache = Cache<PosusumeQuery>()
/// ```
///
/// Call query in task
/// ```swift
///  .task {
///    await cache(.init())
///  }
/// ```
@MainActor
public final class Cache<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published public var data: Query.Data?

    internal func retrieve(query: Query) async {
        do {
            data = try await AppApolloClient.shared.fetchFromCache(query: query)
        } catch {
            data = nil
        }
    }

    public func callAsFunction(_ query: Query) async {
        await retrieve(query: query)
    }
}
