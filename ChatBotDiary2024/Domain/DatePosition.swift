//
//  DatePosition.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/08/11.
//

import Foundation

// 日付に対応する位置を計算
func datePsition(date: Date, referenceDate: Date,in size: CGSize) -> CGPoint {
    let calendar = Calendar.current
        
        // 基準日の月の最初の日付を取得
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        guard let startDate = calendar.date(from: components) else { return CGPoint.zero }
        
        // 月の最初の日が属する曜日を計算
        let weekdayOffset = calendar.component(.weekday, from: startDate) - calendar.firstWeekday
        
        // 日付のオフセットを計算
        let dayOffset = calendar.dateComponents([.day], from: startDate, to: date).day! + weekdayOffset
        
        let column = dayOffset % 7
        let row = dayOffset / 7
        
        let width = size.width / 7
        let height = size.height / 6
        
        return CGPoint(x: width * CGFloat(column) + width / 2, y: height * CGFloat(row) + height / 2)
}
