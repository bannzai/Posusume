import SwiftUI
import Foundation

struct Me: Identifiable, Equatable {
    let id: ID

    struct ID: RawRepresentable, Equatable, Hashable {
        let rawValue: String
    }
}

struct MeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Me?
}

extension EnvironmentValues {
    var me: Me! {
        get {
            self[MeEnvironmentKey.self]
        }
        set {
            self[MeEnvironmentKey.self] = newValue
        }
    }
}

