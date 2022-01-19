//
//  posusumeApp.swift
//  posusume
//
//  Created by Yudai.Hirose on 2021/03/28.
//

import SwiftUI

@main
struct posusumeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        return WindowGroup {
            RootView()
        }
    }
}
