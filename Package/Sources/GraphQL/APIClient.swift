import Apollo
import Foundation
import ApolloSQLite
import SwiftUI

public final class AppApolloClient {
    fileprivate init() { }

    private lazy var interceptorProvider = AppApolloInterceptorProvider(store: store, client: .init(sessionConfiguration: .default, callbackQueue: .main))

    private let store: ApolloStore = {
        let documentsURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        let cache = try! SQLiteNormalizedCache(fileURL: documentsURL.appendingPathComponent("apollo_db.sqlite"))
        return .init(cache: cache)
    }()

    private var headers: [String: String] {
        var headers: [String: String] = [:]
        if let semanticVersion = Plist.shared[.semanticVersion] {
            headers["X-Posusume-Version"] = semanticVersion
        }
        if let buildNumber = Plist.shared[.semanticVersion] {
            headers["X-Posusume-Build-Number"] = buildNumber
        }
        if let languageCode = Locale.autoupdatingCurrent.languageCode {
            headers["X-Posusume-Accept-Language"] = languageCode
        }
        return headers
    }

    public lazy var apollo: ApolloClient = {
        let endpointURL = URL(string: Secret.apiEndpoint)!

        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: endpointURL,
            additionalHeaders: headers
        )

        let client = Apollo.ApolloClient(networkTransport: networkTransport, store: store)
        client.cacheKeyForObject = { $0["id"] }

        return client
    }()
}

// MARK: - async/await
extension AppApolloClient {
    func fetchFromCache<Query: GraphQLQuery>(query: Query) async throws -> Query.Data? {
        try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query, cachePolicy: .returnCacheDataDontFetch) { result in
                do {
                    let response = try result.get()
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else if let errors = response.errors, !errors.isEmpty {
                        continuation.resume(with: .failure(AppGraphQLError(errors)))
                    } else {
                        // NOTE: Occurs when the Local Cache does not hit
                        continuation.resume(returning: nil)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchFromServer<Query: GraphQLQuery>(query: Query) async throws -> Query.Data {
        try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
                do {
                    let response = try result.get()
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else if let errors = response.errors, !errors.isEmpty {
                        continuation.resume(with: .failure(AppGraphQLError(errors)))
                    } else {
                        fatalError("Unexpected result.data and result.errors not found. Maybe apollo-ios or server side application bug")
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func perform<Mutation: GraphQLMutation>(mutation: Mutation) async throws -> Mutation.Data {
        try await withCheckedThrowingContinuation { continuation in
            apollo.perform(mutation: mutation) { result in
                do {
                    let response = try result.get()
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else if let errors = response.errors, !errors.isEmpty {
                        continuation.resume(with: .failure(AppGraphQLError(errors)))
                    } else {
                        fatalError("Unexpected result.data and result.errors not found. Maybe apollo-ios or server side application bug")
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func watch<Query: GraphQLQuery>(query: Query) -> AsyncThrowingStream<Query.Data, Swift.Error> {
        AsyncThrowingStream { continuation in
            let canceller = apollo.watch(query: query) { result in
                do {
                    let response = try result.get()
                    if let data = response.data {
                        continuation.yield(with: .success(data))
                    } else if let errors = response.errors, !errors.isEmpty {
                        continuation.yield(with: .failure(AppGraphQLError(errors)))
                    } else {
                        // NOTE: Skip stream when Release build
                        assertionFailure("Unexpected result.data and result.errors not found. Maybe apollo-ios or server side application bug")
                    }
                } catch {
                    continuation.yield(with: .failure(error))
                }
            }

            continuation.onTermination = { @Sendable _ in
                canceller.cancel()
            }
        }
    }
}

public struct AppApolloClientEnvironmentKey: EnvironmentKey {
    public static var defaultValue: AppApolloClient = .init()
}

public extension EnvironmentValues {
    var apollo: AppApolloClient {
        get {
            self[AppApolloClientEnvironmentKey.self]
        }
        set {
            self[AppApolloClientEnvironmentKey.self] = newValue
        }
    }
}

