import Foundation
import Apollo
import os.log

private let networkLogger = Logger(subsystem: "com.posusume.log", category: "Network")

public struct RequestLoggingInterceptor: ApolloInterceptor {
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            networkLogger.debug(
"""
========= Begin \(request.operation.operationName) =========
\(request.debugDescription)
========= End \(request.operation.operationName) =========
"""
            )
            chain.proceedAsync(request: request, response: response, completion: completion)
    }
}
