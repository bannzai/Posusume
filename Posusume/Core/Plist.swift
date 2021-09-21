import Foundation

public struct Plist {
    enum RequireKey: String {
        case apiEndPoint = "APP_API_ENDPOINT"
    }
    enum OptionalKey: String {
        case semanticVersion = "CFBundleShortVersionString"
        case buildNumber = "CFBundleVersion"
    }

    public static let shared = Plist()
    private init() { }

    internal var plist: [String: Any] = Bundle.main.infoDictionary!

    subscript(key: RequireKey) -> String {
        plist[key.rawValue] as! String
    }
    subscript(key: OptionalKey) -> String? {
        plist[key.rawValue] as? String
    }
}
