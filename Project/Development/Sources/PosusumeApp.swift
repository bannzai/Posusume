//
//  posusumeApp.swift
//  posusume
//
//  Created by Yudai.Hirose on 2021/03/28.
//

import SwiftUI
import Application

@main
struct PosusumeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        return WindowGroup {
            RootView()
        }
    }
}
