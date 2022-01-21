import Foundation
import Apollo
import AppError
import Auth

public class AuthorizationHeaderAddingInterceptor: ApolloInterceptor {
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        guard let currentUser = Auth.firebaseCurrentUser else {
            chain.handleErrorAsync(AppError.unstableNetwork, request: request, response: response, completion: completion)
            return
        }

        currentUser.getIDToken(completion: { idToken, error in
            if let error = error {
                let appError = mappedAppError(from: error)
                if case .unstableNetwork = appError {
                    chain.retry(request: request, completion: completion)
                } else {
                    chain.handleErrorAsync(appError, request: request, response: response, completion: completion)
                }
            } else if let idToken = idToken {
                request.addHeader(name: "Authorization", value: "Bearer \(idToken)")

                chain.proceedAsync(
                    request: request,
                    response: response,
                    completion: completion
                )
            } else {
                fatalError("unexpected error and idToken are nil")
            }
        })
    }
}

