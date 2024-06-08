//
//  FirestoreAPIClient.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/05.
//

import Foundation
import FirebaseFirestore

class FirestoreAPIClient {
    
    let db = Firestore.firestore()
    
    //Firestoreにアカウント情報を保存するメソッド
    func postUserInfo(user: User?) {
        do {
            let userData = try Firestore.Encoder().encode(user)
            
            db.collection("User").addDocument(data: userData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully")
                }
            }
        } catch let error {
            print("Error encoding user: \(error)")
        }
    }
    
    //ユーザー検索メソッド
    func searchUser(email: String, completion: @escaping (Bool) -> Void) {
        
        db.collection("User").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error search document: \(error)")
            }
            
            if querySnapshot!.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    
}
