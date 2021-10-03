import Foundation
import Apollo

@MainActor
public final class Mutation<Mutation: GraphQLMutation>: ObservableObject {
    @Published public private(set) var isProcessing = false

    internal func perform(mutation: Mutation) async throws -> Mutation.Data {
        isProcessing = true
        defer {
            isProcessing = false
        }

        return try await AppApolloClient.shared.perform(mutation: mutation)
    }

    internal func perform<Query: GraphQLQuery>(mutation: Mutation, queryAfterPerform query: Query) async throws -> Mutation.Data {
        let response = try await perform(mutation: mutation)
        _ = try? await AppApolloClient.shared.fetchFromServer(query: query)
        return response
    }

    @discardableResult
    public func callAsFunction(for mutation: Mutation) async throws -> Mutation.Data {
        try await perform(mutation: mutation)
    }

    @discardableResult
    public func callAsFunction<Query: GraphQLQuery>(for mutation: Mutation, queryAfterPerform query: Query) async throws -> Mutation.Data {
        try await perform(mutation: mutation, queryAfterPerform: query)
    }
}
