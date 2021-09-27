import Apollo
import Foundation
import ApolloSQLite

public final class AppApolloClient {
    public static let shared = AppApolloClient()
    private init() { }

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

/// See also apollo-ios DefaultInterceptorProvider
///  https://github.com/apollographql/apollo-ios/blob/88ee167f247eedad81114da28311df17e8ad2afc/Sources/Apollo/DefaultInterceptorProvider.swift
public struct AppApolloInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient
    
    public init(store: ApolloStore, client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    public func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            AuthorizationHeaderAddingInterceptor(),
            RequestLoggingInterceptor(),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}
