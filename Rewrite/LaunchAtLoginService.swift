//
//  LaunchAtLoginService.swift
//  reWriteAI
//
//  Created by Mayomi Ayandiran on 27/09/2025.
//

import Foundation
import ServiceManagement
import Combine

@available(macOS 13.0, *)
class LaunchAtLoginService: ObservableObject {
    @Published var isEnabled: Bool = false {
        didSet {
            toggleLaunchAtLogin(isEnabled)
        }
    }
    
    init() {
        // Check current status on initialization
        isEnabled = SMAppService.mainApp.status == .enabled
    }
    
    func toggleLaunchAtLogin(_ enable: Bool) {
        do {
            if enable {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            DispatchQueue.main.async {
                self.isEnabled = !enable
            }
        }
    }
}
