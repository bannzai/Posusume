import Foundation
import Apollo
import Combine
import SwiftUI

public final class Query<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published public private(set) var data: Query.Data?
    @Published public private(set) var error: Error?
    public func fetch(query: Query, cachePolicy: CachePolicy) {
        AppApolloClient.shared.apollo.fetch(query: query, cachePolicy: cachePolicy) { [weak self] result in
            do {
                let result = try result.get()
                self?.data = result.data
            } catch {
                self?.error = error
            }
        }
    }
}
