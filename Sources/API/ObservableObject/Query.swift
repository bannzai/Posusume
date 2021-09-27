import Foundation
import Apollo
import Combine
import SwiftUI

public final class Query<Query: Apollo.GraphQLQuery>: ObservableObject {
    @Published internal var data: Query.Data?
    @Published internal var error: Error?
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
