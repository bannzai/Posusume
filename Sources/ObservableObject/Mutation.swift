import Foundation
import Apollo

@MainActor
public final class Mutation<Mutation: GraphQLMutation>: ObservableObject {
    @Published public private(set) var isProcessing = false
    @Published public private(set) var response: Mutation.Data?
    @Published public private(set) var error: Error?

    internal func perform(mutation: Mutation) async {
        isProcessing = true
        defer {
            isProcessing = false
        }

        do {
            response = try await AppApolloClient.shared.perform(mutation: mutation)
        } catch {
            self.error = error
        }
    }

    internal func perform<Query: GraphQLQuery>(mutation: Mutation, queryAfterPerform query: Query) async {
        await perform(mutation: mutation)
        _ = try? await AppApolloClient.shared.fetchFromServer(query: query)
    }

    public func callAsFunction(for mutation: Mutation) async {
        await perform(mutation: mutation)
    }

    public func callAsFunction<Query: GraphQLQuery>(for mutation: Mutation, queryAfterPerform query: Query) async {
        await perform(mutation: mutation, queryAfterPerform: query)
    }
}
