//
//  Message.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/07/08.
//

import Foundation

struct Message: Identifiable, Equatable {
    var id: String
    var message: String
    var isUser: String
    var showDiaryButton: Bool = false
    var isLoading: Bool = false
    
    static func ==(lhs: Message, rhs:Message) -> Bool {
        return lhs.id == rhs.id && lhs.message == rhs.message && lhs.isUser == rhs.isUser
    }
    
}

