import SwiftUI
import Foundation

public struct Me: Identifiable, Equatable {
    public let id: ID

    public struct ID: RawRepresentable, Equatable, Hashable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

public struct MeEnvironmentKey: EnvironmentKey {
    public static var defaultValue: Me?
}

public extension EnvironmentValues {
    var me: Me! {
        get {
            self[MeEnvironmentKey.self]
        }
        set {
            self[MeEnvironmentKey.self] = newValue
        }
    }
}

