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

        var errorDescription: String? {
            switch self {
            case .badResponse(let message):
                return message
            }
        }
    }

  
    func rewriteMenuText(input: String) async throws -> String {
        guard let apiKey else {
            throw NSError(domain: "No API key set", code: 401, userInfo: [NSLocalizedDescriptionKey: "No API key set. Please set one in the app settings."])
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
            let bodyStr = String(data: data, encoding: .utf8) ?? "<no body>"
            print("❌ API Error — Status: \((response as? HTTPURLResponse)?.statusCode ?? -1), Body: \(bodyStr)")
            throw OpenAIError.badResponse("Status not OK: \((response as? HTTPURLResponse)?.statusCode ?? -1) — \(bodyStr)")
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        if let choices = json?["choices"] as? [[String: Any]],
           let message = choices.first?["message"] as? [String: Any],
           let content = message["content"] as? String {
            return content.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        throw OpenAIError.badResponse("something went wrong")
    }
}
