import Foundation
import Apollo
import SwiftUI

/// Watch all GraphQL response with `GraphQL Query` and published data
///
/// Declare
/// ```swift
///  @StateObject var watch = Watch<PosusumeQuery>()
/// ```
///
/// Call query in task
/// ```swift
///  .task {
///    for await data in watch(for: PosusumeQuery()) {
///      print(data)
///    }
///  }
///
/// ```
@MainActor public final class Watch<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Environment(\.apollo) var apollo

    @Published public private(set) var isFirstFetching = false

    public init() { }

    internal func watch(query: Query) -> AsyncStream<Query.Data> {
        isFirstFetching = true
        defer {
            isFirstFetching = false
        }


        return .init { continuation in
            Task { @MainActor in
                do {
                    for try await data in apollo.watch(query: query) {
                        isFirstFetching = false
                        continuation.yield(with: .success(data))
                    }
                } catch {
                    isFirstFetching = false
                }
            }
        }
    }

    public func callAsFunction(for query: Query) -> AsyncStream<Query.Data> {
        watch(query: query)
    }
}
