//
//  Chat.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/27.
//

import Foundation


struct ChatRequest: Encodable {
    let query: String
    let inputs: [String: AnyEncodable]
    let response_mode: String
    let conversation_id : String
    let user: String
    let files: [File]
}

struct File: Encodable {
    let type: String
    let transfer_method: String
    let url: String
}

struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

struct ChatResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let text: String
    let conversationID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case text
        case conversationID = "conversation_id"
    }
}
