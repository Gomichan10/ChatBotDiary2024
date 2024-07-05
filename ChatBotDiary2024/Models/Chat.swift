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
    let event: String
    let messageID: String
    let conversationID: String
    let mode: String
    let answer: String
    let metadata: Metadata
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case event
        case messageID = "message_id"
        case conversationID = "conversation_id"
        case mode
        case answer
        case metadata
        case createdAt = "created_at"
    }
}

struct Metadata: Codable {
    let usage: Usage
    let retrieverResources: [RetrieverResource]?
    
    enum CodingKeys: String, CodingKey{
        case usage
        case retrieverResources = "retriever_resources"
    }
}

struct Usage: Codable {
    let promptTokens: Int
    let promptUnitPrice: String
    let promptPriceUnit: String
    let promptPrice: String
    let completionTokens: Int
    let completionUnitPrice: String
    let completionPriceUnit: String
    let completionPrice: String
    let totalTokens: Int
    let totalPrice: String
    let currency: String
    let latency: Double
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case promptUnitPrice = "prompt_unit_price"
        case promptPriceUnit = "prompt_price_unit"
        case promptPrice = "prompt_price"
        case completionTokens = "completion_tokens"
        case completionUnitPrice = "completion_unit_price"
        case completionPriceUnit = "completion_price_unit"
        case completionPrice = "completion_price"
        case totalTokens = "total_tokens"
        case totalPrice = "total_price"
        case currency
        case latency
    }
}

struct RetrieverResource: Codable {
    let position: Int
    let datasetID: String
    let datasetName: String
    let documentID: String
    let documentName: String
    let segmentID: String
    let score: Double
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case position
        case datasetID = "dataset_id"
        case datasetName = "dataset_name"
        case documentID = "document_id"
        case documentName = "document_name"
        case segmentID = "segment_id"
        case score
        case content
    }
}
