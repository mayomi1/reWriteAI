//
//  RewriteDialog.swift
//  Rewrite
//
//  Created by Mayomi Ayandiran on 24/09/2025.
//

import SwiftUI
import AppKit

struct RewriteDialog: View {
    @State private var inputText: String = ""
    @State private var outputText: String = ""
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Rewrite Menu Text")
                .font(.title2)
                .bold()

            // Input text
            Text("Original Text")
                .font(.headline)
            TextEditor(text: $inputText)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .lineSpacing(6)
                .frame(minHeight: 140)
                .padding(6)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))

            // Rewrite button
            Button(action: {
                Task { await rewriteAction() }
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Rewrite with AI")
                }
            }
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            .buttonStyle(.borderedProminent)

            // Output text
            if !outputText.isEmpty || isLoading {
                Text("Generated Response")
                    .font(.headline)
                
                TextEditor(text: $outputText)
                    .frame(minHeight: 120)
                    .padding(6)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue.opacity(0.6)))
                
                
                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(outputText, forType: .string)
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
            
            

            Spacer()
        }
        .padding(20)
        .frame(width: 420, height: 540)
    }

    func rewriteAction() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await OpenAIService.shared.rewriteMenuText(input: inputText)
            outputText = result
        } catch {
            outputText = "⚠️ Error: \(error.localizedDescription)"
        }
    }
}
