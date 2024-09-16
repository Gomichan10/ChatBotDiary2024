//
//  FindCalendar.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/08/27.
//

import Foundation
import FSCalendar

func findCalendar(viewController: UIViewController?) -> FSCalendar? {
    if let calendar = viewController?.view.subviews.first(where: { $0 is FSCalendar }) as? FSCalendar {
        return calendar
    }
    return nil
}
