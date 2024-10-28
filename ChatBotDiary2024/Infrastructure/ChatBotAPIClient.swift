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
    
    // ChatGPTAPIにメッセージを送受信するメソッド
    func sendMessageChatGPT(messages: [[String: String]],isSixMessage: Bool, completion: @escaping ([[String: String]]?) -> Void) {
        var responseMessages: [[String: String]] = []
        
        var mutableMessages = messages
        
        if isSixMessage {
            let message = ["role": "user", "content": "日記にして"]
            mutableMessages.append(message)
            print(mutableMessages)
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-4",
            "messages": mutableMessages
        ]
        
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let chatGPTResponse = try? JSONDecoder().decode(ChatGPT.self, from: data) {
                        print(chatGPTResponse)
                        if let firstChoice = chatGPTResponse.choices.first {
                            let content = firstChoice.message.content
                            // レスポンスメッセージを追加
                            responseMessages.append(["role": "assistant", "content": content])
                            
                            completion(responseMessages)
                        } else {
                            completion(nil)
                        }
                    } else if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        print("API Error: \(apiError.error.message)")
                        completion(nil)
                    } else {
                        print("Unexpected data format")
                        completion(nil)
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}
