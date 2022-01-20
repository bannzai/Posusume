import Foundation
import Apollo
import SwiftUI

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
    @Environment(\.apollo) var apollo

    @Published public private(set) var isFetchingFromCache = false
    @Published public private(set) var isFetchingFromServer = false

    public var isFetching: Bool { isFetchingFromCache || isFetchingFromServer }

    public init() { }

    public func cache(for query: Query) async -> Query.Data? {
        isFetchingFromCache = true
        defer {
            isFetchingFromCache = false
        }

        do {
            return try await apollo.fetchFromCache(query: query)
        } catch {
            return nil
        }
    }

    internal func fetch(query: Query) async throws -> Query.Data {
        isFetchingFromServer = true
        defer {
            isFetchingFromServer = false
        }

        return try await apollo.fetchFromServer(query: query)
    }

    public func callAsFunction(for query: Query) async throws -> Query.Data {
        try await fetch(query: query)
    }
}
