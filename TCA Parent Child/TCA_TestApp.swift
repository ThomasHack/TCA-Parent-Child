//
//  TCA_TestApp.swift
//  TCA Test
//
//  Created by Hack, Thomas on 04.08.21.
//

import SwiftUI

@main
struct TCA_Parent_ChildApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(store: Main.store)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
