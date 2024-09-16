//
//  ExtractString.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/08/09.
//

import Foundation

// 「」内の文字列を抽出するメソッド
func extractString(from text: String) -> String? {
    guard let startRange = text.range(of: "「") else {
        return nil
    }
    
    guard let endRange = text.range(of: "」", options: .backwards) else {
        return nil
    }
    
    if startRange.upperBound < endRange.lowerBound {
        let extractedRange = startRange.upperBound..<endRange.lowerBound
        return String(text[extractedRange])
    }
    
    return nil
}
