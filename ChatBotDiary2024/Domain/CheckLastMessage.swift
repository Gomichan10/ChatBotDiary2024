//
//  checkLastMessage.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/07/29.
//

import Foundation

// 文字列に「」で囲まれた文字列がないかチェックするメソッド
func checkLastMessage(message: String) -> Bool {
    let pattern = "「.*?」"
    if let _ = message.range(of: pattern, options: .regularExpression) {
        return true
    } else {
        return false
    }
}
