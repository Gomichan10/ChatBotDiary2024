//
//  UserAPIClient.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/05/27.
//

import Foundation
import FirebaseAuth

class UserAPIClient {
    
    var user: User?
    
    //ログインメソッド
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("error:(\(error.localizedDescription))")
                completion(false)
            } else {
                print(authResult?.user.uid ?? "No UserID")
                completion(true)
            }
        }
    }
    
    //アカウント作成メソッド
    func createUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            let userInfo = authResult?.user
            
            if let error = error {
                print("error:(\(error.localizedDescription))")
                completion(false)
            } else {
                self.user = User(email: userInfo?.email ?? "No Email", id: userInfo?.uid ?? "No ID")
                FirestoreAPIClient().postUserInfo(user: self.user)
                completion(true)
            }
        }
    }
    
}
