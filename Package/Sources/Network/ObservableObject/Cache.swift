import Foundation
import Apollo
import SwiftUI

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
///    await cache(for: PosusumeQuery())
///  }
/// ```
@MainActor
public final class Cache<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Environment(\.apollo) var apollo

    @Published public private(set) var isFetching = false

    internal func retrieve(query: Query) async -> Query.Data? {
        isFetching = true
        defer {
            isFetching = false
        }

        do {
            return try await apollo.fetchFromCache(query: query)
        } catch {
            return nil
        }
    }

    public func callAsFunction(for query: Query) async -> Query.Data? {
        return await retrieve(query: query)
    }
}
