//
//  RewriteApp.swift
//  reWriteAI
//
//  Created by Mayomi Ayandiran on 24/09/2025.
//

import SwiftUI

@main
struct reWriteAIApp: App {
    var body: some Scene {
        MenuBarExtra("reWriteAI", systemImage: "pencil") {
            MenuView()
                .frame(width: 360)
        }
        
        Settings {
            SettingsView()
        }
    
    }
}
