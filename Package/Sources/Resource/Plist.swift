import Foundation

public struct Plist {
    public enum OptionalKey: String {
        case semanticVersion = "CFBundleShortVersionString"
        case buildNumber = "CFBundleVersion"
    }

    public static let shared = Plist()
    private init() { }

    internal var plist: [String: Any] = Bundle.main.infoDictionary!

    public subscript(key: OptionalKey) -> String? {
        plist[key.rawValue] as? String
    }
}
