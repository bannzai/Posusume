//
//  Copyright (c) 2018-2020 Appify Technologies, Inc.
//

import SwiftUI

struct LoginHandlerEnvironmentKey: EnvironmentKey {
    static var defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var logoutHandler: () -> Void {
        get {
            self[LoginHandlerEnvironmentKey.self]
        }
        set {
            self[LoginHandlerEnvironmentKey.self] = newValue
        }
    }
}

