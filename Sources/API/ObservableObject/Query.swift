import Foundation
import Apollo
import Combine
import SwiftUI

public final class Query<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published public private(set) var isFetching: Bool = false
    @Published public private(set) var data: Query.Data?
    @Published public private(set) var error: Error?

    public func fetch(query: Query, cachePolicy: CachePolicy) async {
        isFetching = true
        defer {
            isFetching = false
        }

        do {
            data = try await AppApolloClient.shared.fetch(query: query, cachePolicy: cachePolicy).data
        } catch {
            self.error = error
        }
    }
}
