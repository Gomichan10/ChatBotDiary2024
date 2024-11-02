//
//  KeyboardResponder.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/10/01.
//

import Foundation
import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return 0
                }
                print("Keyboard frame: \(frame.height)")  // キーボードの高さを確認
                if notification.name == UIResponder.keyboardWillHideNotification {
                    return 0
                } else {
                    return frame.height
                }
            }
            .assign(to: \.currentHeight, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
