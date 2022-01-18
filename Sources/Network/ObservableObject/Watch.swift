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

    internal func watch(query: Query) -> AsyncThrowingStream<Query.Data, Swift.Error> {
        apollo.watch(query: query)
    }

    public func callAsFunction(query: Query) -> AsyncThrowingStream<Query.Data, Swift.Error> {
        watch(query: query)
    }
}
