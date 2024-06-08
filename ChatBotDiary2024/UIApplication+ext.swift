//
//  UIApplication+ext.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/05.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
