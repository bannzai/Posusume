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
