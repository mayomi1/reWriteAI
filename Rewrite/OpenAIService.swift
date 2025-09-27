//
//  OpenAIService.swift
//  reWriteAI
//
//  Created by Mayomi Ayandiran on 24/09/2025.
//

import Foundation
import SwiftUI

final class OpenAIService {
    static let shared = OpenAIService()
    
    @AppStorage("DEV_OPENAI_API_KEY") private var devApiKey: String = ""
    @AppStorage("SYSTEM_PROMPT") private var systemPrompt: String = Constants.defaultSystemPrompt
    @AppStorage("OPENAI_MODEL") private var selectedModel: String = Constants.defaultModel

    private var apiKey: String? {
        if !devApiKey.isEmpty {
            return devApiKey
        }
        if let envApiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !envApiKey.isEmpty {
            return envApiKey
        }
        return nil
    }
    
    enum OpenAIError: Error, LocalizedError {
        case badResponse(String)
        case invalidApiKey
        case noApiKey
        case unknownError

        var errorDescription: String? {
            switch self {
            case .badResponse(let message):
                return message
            case .invalidApiKey:
                return "Invalid API key. Please check your OpenAI API key in the app settings."
            case .noApiKey:
                return "No API key set. Please set your OpenAI API key in the app settings."
            case .unknownError:
                return "An unexpected error occurred. Please try again."
            }
        }
    }

  
    func rewriteMenuText(input: String) async throws -> String {
        guard let apiKey else {
            throw OpenAIError.noApiKey
        }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": selectedModel,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": input]
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let bodyStr = String(data: data, encoding: .utf8) ?? "<no body>"
            print("❌ API Error — Status: \(statusCode), Body: \(bodyStr)")
            
            // Handle specific error cases
            if statusCode == 401 {
                // Check if it's an invalid API key error
                if bodyStr.contains("invalid_api_key") || bodyStr.contains("Incorrect API key") {
                    throw OpenAIError.invalidApiKey
                }
                throw OpenAIError.invalidApiKey
            }
            
            // For other errors, try to parse the JSON response for a user-friendly message
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = json["error"] as? [String: Any],
               let message = error["message"] as? String {
                throw OpenAIError.badResponse(message)
            }
            
            throw OpenAIError.unknownError
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        if let choices = json?["choices"] as? [[String: Any]],
           let message = choices.first?["message"] as? [String: Any],
           let content = message["content"] as? String {
            return content.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        throw OpenAIError.unknownError
    }
}
