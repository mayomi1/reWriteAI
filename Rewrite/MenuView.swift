//
//  MenuView.swift
//  Rewrite
//
//  Created by Mayomi Ayandiran on 24/09/2025.
//

import SwiftUI
import AppKit

struct MenuView: View {
    @State private var originalText: String = ""
    @State private var rewrittenText: String = ""
    @State private var isLoading = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Original Text")
                    .font(.headline)

                TextEditor(text: $originalText)
                    .frame(height: 120)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.4)))

                HStack {
                    Button("Rewrite with AI") {
                        Task { await rewriteAction() }
                    }
                    .disabled(originalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                    .buttonStyle(.borderedProminent)

                    Button("Paste from Clipboard") {
                        if let clip = NSPasteboard.general.string(forType: .string) {
                            originalText = clip
                        }
                    }
                }

                if !rewrittenText.isEmpty {
                    Text("Result")
                        .font(.headline)
                    TextEditor(text: $rewrittenText)
                        .frame(height: 120)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.blue.opacity(0.6)))

                    Button("Copy to Clipboard") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(rewrittenText, forType: .string)
                    }
                }

                Divider()

                Button("Open Rewrite Dialog") {
                    DialogWindow.show {
                        RewriteDialog()
                    }
                }
                .buttonStyle(.bordered)
                
                Divider()
                
                Button("Settings") {
                    DialogWindow.show {
                        SettingsView()
                    }
                }
                .buttonStyle(.bordered)
                
                Divider()
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }

            }
        }
    
    func rewriteAction() async {
            isLoading = true
            defer { isLoading = false }

            do {
                let result = try await OpenAIService.shared.rewriteMenuText(input: originalText)
                rewrittenText = result
            } catch {
                rewrittenText = "⚠️ Error: \(error.localizedDescription)"
            }
        }
}
