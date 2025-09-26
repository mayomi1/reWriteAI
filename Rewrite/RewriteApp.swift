//
//  RewriteApp.swift
//  Rewrite
//
//  Created by Mayomi Ayandiran on 24/09/2025.
//

import SwiftUI

@main
struct RewriteApp: App {
    var body: some Scene {
        MenuBarExtra("Menu Rewriter", systemImage: "pencil") {
            MenuView()
                .frame(width: 360)
        }
        
        Settings {
            SettingsView()
        }
    }
}
