//
//  posusumeApp.swift
//  posusume
//
//  Created by Yudai.Hirose on 2021/03/28.
//

import SwiftUI
import Firebase

@main
struct posusumeApp: App {
    var body: some Scene {
        FirebaseApp.configure()
        return WindowGroup {
            ContentView()
        }
    }
}
