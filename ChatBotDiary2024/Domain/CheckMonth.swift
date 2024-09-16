//
//  CheckMonth.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/08/09.
//

import Foundation


// 選択された日付と日記が追加されている日付の年月が同じかどうかをチェックするメソッド
func checkMonth(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    let components1 = calendar.dateComponents([.year, .month], from: date1)
    let components2 = calendar.dateComponents([.year, .month], from: date2)
    return components1.year == components2.year && components1.month == components2.month
}
