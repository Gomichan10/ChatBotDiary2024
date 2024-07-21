import Foundation
import Alamofire
import FirebaseAuth

class ChatBotAPIClient {
    private let apiKey = "ChatGPT-APIKey"
    private let apiUrl = "https://api.openai.com/v1/chat/completions"
    
    // ChatGPTAPIにメッセージを送受信するメソッド
    func sendMessageChatGPT(messages: [[String: String]], completion: @escaping ([[String: String]]?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages
        ]
        
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ChatGPT.self) { response in
            switch response.result {
            case .success(let gptResponse):
                if let firstChoice = gptResponse.choices.first {
                    let content = firstChoice.message.content
                    var responseMessage: [[String: String]] = [["role": "assistant", "content": content]]
                    completion(responseMessage)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                if let data = response.data, let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                    print("API Error: \(apiError.error.message)")
                } else {
                    print("Error: \(error)")
                }
                completion(nil)
            }
        }
    }

}

