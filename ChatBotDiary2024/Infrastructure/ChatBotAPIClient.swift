//
//  ChatBotAPIClient.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/09/16.
//

import Foundation
import Alamofire
import FirebaseAuth
import Keys

class ChatBotAPIClient {
    private var apiKey: String
    private var apiUrl: String
    
    init() {
        let keys = ChatBotDiary2024Keys()
        self.apiKey = keys.openAIAPIKey
        self.apiUrl = "https://api.openai.com/v1/chat/completions"
    }
    
    // URLSessionによるAPIの実装
    func sendMessageGPT(messages: [[String: String]], isSixMessage: Bool) async throws -> [[String: String]]? {
        var mutableMessages = messages
        
        if isSixMessage {
            let message = ["role": "user", "content": "日記にして"]
            mutableMessages.append(message)
        }
        
        // リクエストの準備
        guard let url = URL(string: apiUrl) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Jsonボディの設定
        let parameters: [String: Any] = [
            "model": "gpt-4",
            "messages": mutableMessages
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        // 非同期リクエスト
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // レスポンスをデコード
        if let chatGPTResponse = try? JSONDecoder().decode(ChatGPT.self, from: data),
           let firstChoice = chatGPTResponse.choices.first {
            let content = firstChoice.message.content
            return [["role": "assistant", "content": content]]
        } else if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
            print("API Error: \(apiError.error.message)")
            throw NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: apiError.error.message])
        } else {
            print("Unexpected data format")
            return nil
        }
    }
}
