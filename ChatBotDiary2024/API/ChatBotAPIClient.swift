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
    func sendMessageChatbot(message: String, completion: @escaping (Result<ChatResponse, Error>) -> Void) {
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
        
        AF.request(endpoint, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: ChatResponse.self) { response in
            switch response.result {
            case .success(let chatResponse):
                completion(.success(chatResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
