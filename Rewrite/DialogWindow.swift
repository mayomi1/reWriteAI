//
//  DialogWindow.swift
//  reWriteAI
//
//  Created by Mayomi Ayandiran on 24/09/2025.
//

import SwiftUI
import AppKit

class DialogWindow {
    static func show<Content: View>(@ViewBuilder content: @escaping () -> Content) {
        let hostingController: NSHostingController<Content> = NSHostingController(rootView: content())
        let window: NSWindow = NSWindow(contentViewController: hostingController)
        window.styleMask = [.titled, .closable, .resizable]
        window.setContentSize(NSSize(width: 420, height: 480))
        window.title = "Rewrite Menu Text"
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true) // bring to front
    }
}
