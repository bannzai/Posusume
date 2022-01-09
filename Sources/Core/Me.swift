import SwiftUI
import Foundation

public struct Me: Identifiable, Equatable {
    public let id: ID
    public var isAnonymous: Bool

    public struct ID: RawRepresentable, Equatable, Hashable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

@dynamicMemberLookup
public struct MeMembers {
    public let me: Me!
    
    public init(me: Me) {
        self.me = me
    }

    internal init() {
        me = nil
    }

    public subscript<U>(dynamicMember keyPath: KeyPath<Me, U>) -> U {
        return me![keyPath: keyPath]
    }
}

public struct MeEnvironmentKey: EnvironmentKey {
    public static var defaultValue: MeMembers = .init()
}

public extension EnvironmentValues {
    var me: MeMembers {
        get {
            self[MeEnvironmentKey.self]
        }
        set {
            self[MeEnvironmentKey.self] = newValue
        }
    }
}

