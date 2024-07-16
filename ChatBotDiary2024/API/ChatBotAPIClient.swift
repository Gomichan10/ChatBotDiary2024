import Foundation
import Alamofire
import FirebaseAuth

class ChatBotAPIClient {
    private let apiKey = "YOUR_API_KEY_HERE" // 本来のAPIキーを削除または置き換え
    private let apiUrl = "https://api.openai.com/v1/chat/completions"
    
    // ChatGPTAPIにメッセージを送受信するメソッド
    func sendMessageChatGPT(messages: [[String: String]], completion: @escaping ([[String: String]]?) -> Void) {
        var responseMessages: [[String: String]] = []
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages
        ]
        
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let chatGPTResponse = try? JSONDecoder().decode(ChatGPT.self, from: data) {
                        print(chatGPTResponse)
                        if let firstChoice = chatGPTResponse.choices.first {
                            let content = firstChoice.message.content
                            // レスポンスメッセージを追加
                            responseMessages.append(["role": "assistant", "content": content])
                            
                            completion(responseMessages)
                        } else {
                            completion(nil)
                        }
                    } else if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        print("API Error: \(apiError.error.message)")
                        completion(nil)
                    } else {
                        print("Unexpected data format")
                        completion(nil)
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }

    // Difyにメッセージを送るためのメソッド
    func sendMessageChatbot(message: String, completion: @escaping (Result<ChatResponse, Error>) -> Void) {
        let apiKey = "YOUR_API_KEY_HERE" // 本来のAPIキーを削除または置き換え
        let endpoint = "https://api.dify.ai/v1/chat-messages"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "message": message
        ]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                    completion(.success(chatResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

