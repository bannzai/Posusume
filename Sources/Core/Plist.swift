import Foundation

public struct Plist {
    enum OptionalKey: String {
        case semanticVersion = "CFBundleShortVersionString"
        case buildNumber = "CFBundleVersion"
    }

    public static let shared = Plist()
    private init() { }

    internal var plist: [String: Any] = Bundle.main.infoDictionary!

    subscript(key: OptionalKey) -> String? {
        plist[key.rawValue] as? String
    }
}
