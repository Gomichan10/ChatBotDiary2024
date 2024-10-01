//
//  FirestoreAPIClient.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/05.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreAPIClient {
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    // Firestoreにアカウント情報を保存するメソッド
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
    
    // ユーザー検索メソッド
    func searchUser(email: String, completion: @escaping (Bool) -> Void) {
        
        db.collection("User").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error search document: \(error)")
            }
            
            if snapshot!.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    // 日記追加メソッド
    func saveDiary(diary: Diary, completion: @escaping (Bool) -> Void) {
        do {
            let encodeDiary = try Firestore.Encoder().encode(diary)
            
            db.collection("diary").addDocument(data: encodeDiary) { error in
                if let error = error {
                    print("Error saving diary entry: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch let error {
            print("Error encoding user: \(error)")
        }
    }
    
    // 日付取得メソッド
    func fetchDiary(completion: @escaping (Result<[Date], Error>) -> Void) {
        
        db.collection("diary").whereField("id", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching diary dates: \(error.localizedDescription)")
                completion(.failure(error.localizedDescription as! Error))
            } else {
                let diaryDatas: [Date] = snapshot?.documents.compactMap { document in
                    if let timestamp = document.data()["date"] as? Timestamp {
                        return timestamp.dateValue()
                    }
                    return nil
                } ?? []
                completion(.success(diaryDatas))
            }
        }
        
    }
    
    // カレンダーを選択した際に日記を取得するメソッド
    func getDiary(date: Date, completion: @escaping (Result<Diary, Error>) -> Void) {
        
        // 日本標準時間に設定
        let calendar = Calendar.current
        let jstTimeZone = TimeZone(identifier: "Asia/Tokyo")!
        let components = calendar.dateComponents(in: jstTimeZone, from: date)
        
        // その日の日付の0時と23時59ふんの範囲を設定
        let startOfDay = calendar.date(from: components)!
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Firestoreで使うタイムスタンプに変換
        let startTimeStamp = Timestamp(date: startOfDay)
        let endTimeStamp = Timestamp(date: endOfDay)
        
        db.collection("diary")
            .whereField("id", isEqualTo: uid)
            .whereField("date", isGreaterThanOrEqualTo: startTimeStamp)
            .whereField("date", isLessThan: endTimeStamp)
            .getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else if let documents = snapshot?.documents, let document = documents.first {
                if let diary = document["diaryText"] as? String {
                    print(diary)
                    if let diaryDate = document["date"] as? Timestamp {
                        let diaryModel = Diary(date: diaryDate.dateValue(), diaryText: diary, id: UUID().uuidString)
                        completion(.success(diaryModel))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Diary field is missing"])))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No document found"])))
            }
        }
        
    }
    
}
