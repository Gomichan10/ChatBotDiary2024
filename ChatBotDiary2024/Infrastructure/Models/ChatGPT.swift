//
//  File.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/07/13.
//

import Foundation

struct ChatGPT: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage?
    
    struct Choice: Decodable {
        let message: Message
        let finish_reason: String
        let index: Int
        
        struct Message: Decodable {
            let role: String
            let content: String
        }
    }
    
    struct Usage: Decodable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
    
}

struct APIError: Decodable {
    let error: ErrorDetail
    
    struct ErrorDetail: Decodable {
        let code: String
        let message: String
        let param: String?
        let type: String
    }
}
