import Foundation

public enum AppError: Error, LocalizedError {
    case requireLogin
    case userDeleted
    case unstableNetwork
    case fatal
    case support(error: Error, code: Int, domain: String, userInfo: [String: Any])
    case unexpected(error: Error)

    public var errorDescription: String? {
        switch self {
        case .requireLogin:
            return "認証期限切れです。再ログインしてください"
        case .userDeleted:
            return "ユーザーが既に削除されています"
        case .unstableNetwork:
            return "ネットワークが不安定です。通信環境をお確かめのうえ再度お試しください"
        case .fatal:
            return "不正なリクエストです"
        case let .support(error, code, domain, userInfo):
            return """
                    不明なエラーが発生しました。下記の情報を添えてサポートまでお問い合わせください。
                    error: \(error)
                    code: \(code),
                    domain: \(domain)
                    userInfo: \(userInfo)
                    """
        case let .unexpected(error):
            return error.localizedDescription
        }
    }
}
