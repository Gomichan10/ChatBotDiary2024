//
//  ChatBotAPIClient.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/26.
//

import Foundation
import Alamofire
import FirebaseAuth

class ChatBotAPIClient {
    
    // Difyにメッセージを送るためのメソッド
    func sendMessageToChatbot(message: String, completion: @escaping (Bool) -> Void) {
        let apiKey = "app-bswJF8iUw8XQncJVJEf75MCS"
        let endpoint = "https://api.dify.ai/v1/chat-messages"
        
        guard let user = Auth.auth().currentUser else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let request = ChatRequest(
            query: message,
            inputs: [:],
            response_mode: "blocking",
            conversation_id: "",
            user: user.uid,
            files: []
        )
        
        AF.request(endpoint, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if let stringData = String(data: data, encoding: .utf8) {
                    print(stringData)
                }
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
}
