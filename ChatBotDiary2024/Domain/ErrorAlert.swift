//
//  ErrorAlert.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/05.
//

import Foundation
import UIKit

class ErrorAlert {
    
    func ErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "入力が完了していません", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
