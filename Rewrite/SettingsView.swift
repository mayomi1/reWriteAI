//
//  SettingsView.swift
//  reWriteAI
//
//  Created by Mayomi Ayandiran on 24/09/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("DEV_OPENAI_API_KEY") private var devApiKey: String = ""
    @AppStorage("SYSTEM_PROMPT") private var systemPrompt: String = Constants.defaultSystemPrompt
    @AppStorage("TEMP_SYSTEM_PROMPT") private var tempSystemPrompt: String = ""
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Settings")
                    .font(.title2)
                    .bold()

                Text("OpenAI API Key")
                    .font(.headline)

                SecureField("Enter your API Key", text: $devApiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 8)
                
                Divider()
                
                Text("System prompt")
                    .font(.headline)
            
                
                TextEditor(text: $tempSystemPrompt)
                    .frame(minHeight: 120)
                    .padding(6)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue.opacity(0.6)))
                
                HStack {
                    Button("Reset") {
                        tempSystemPrompt = Constants.defaultSystemPrompt
                        systemPrompt = Constants.defaultSystemPrompt
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Apply") {
                        systemPrompt = tempSystemPrompt
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 8)
                
                Spacer()
                
                Text("Your API key is stored locally on this Mac.")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
            .frame(width: 400, height: 400)
            .navigationTitle(Text("Settings"))
            .onAppear {
                if tempSystemPrompt.isEmpty {
                    tempSystemPrompt = systemPrompt
                }
            }
        }
}
