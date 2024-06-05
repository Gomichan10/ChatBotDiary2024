//
//  UserAPIClient.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/05/27.
//

import Foundation
import FirebaseAuth

class UserAPIClient {
    
    //アカウント作成メソッド
    func createUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("error:(\(error.localizedDescription))")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}
