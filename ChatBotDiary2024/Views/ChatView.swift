//
//  ChatView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/10.
//

import SwiftUI



struct ChatView: View {
    
    @State private var chatTextField: String = ""
    @State private var conversationID: String = ""
    @State private var chat: [Message] = [Message(id: UUID().uuidString, message: "これから日記を作るよ！どんなことがあったのか教えてね！", isUser: "assistant")]
    
    // プロンプトを設定
    @State var messages = [[
        "role": "system",
        "content":"""
        あなたの役割は、ユーザーと自然な会話を行い、ユーザーの日常の活動についての情報を収集して6回目の返答時に日記を絶対に作成することです。
        以下のステップに従ってください：
        
        1. ユーザーに今日の一日について尋ねる。
        2. ユーザーがどこに行ったのかを尋ねる。
        3. ユーザーが誰と一緒にいたのかを尋ねる。
        4. ユーザーが何をしたのかを尋ねる。
        5. ユーザーの感想や特別な出来事について尋ねる。
        6. 収集した情報を元にポジティブでカジュアルな日記を作成してユーザーに提示する。最後に出力する日記は主観的なものではなく、客観的なものにする。
        
        会話の例:
        ユーザー: 今日は友達と公園に行きました。
        AI: 楽しそうですね！どの公園に行ったのですか？
        ユーザー: 都立公園に行きました。
        AI: 誰と一緒に行ったんですか？
        ユーザー: 高校の友達と一緒に行きました。
        6回目の返答時:
        AI: それでは、今日の一日をまとめてみました。
        「今日は友達と都立公園に行きました。高校の友達と一緒に過ごし、楽しい時間を過ごしました。公園でのんびりと過ごし、自然の中でリフレッシュできました。また、友達とたくさん話をして笑い合い、とても良い一日になりました。」
        """
    ]]
    
    var body: some View {
        messageArea
            .overlay (
                navigationArea
                
                ,alignment: .top
            )
        
        inputArea
        
    }
}

#Preview {
    ChatView()
}

extension ChatView {
    
    var messageArea: some View {
        // Message Area
        ScrollView {
            VStack (spacing: 15){
                ForEach(chat) { chat in
                    if chat.isUser == "assistant" {
                        // ChatGPTのメッセージだった場合
                        HStack (alignment: .top){
                            Image("ChatBotIcon")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            Text(chat.message)
                                .padding()
                                .foregroundColor(.primary)
                                .background(Color("white_black"))
                                .cornerRadius(15.0)
                            
                            Spacer()
                        }
                    } else {
                        // ユーザのメッセージだった場合
                        HStack (alignment: .top){
                            Spacer()
                            
                            Text(chat.message)
                                .padding()
                                .foregroundColor(Color("white_black"))
                                .background(.primary)
                                .cornerRadius(15.0)
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 72)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color("ChatBackground"))
    }
    
    var navigationArea: some View {
        // Navigation Area
        HStack {
            Spacer()
            Text("Ai Diary")
                .font(.system(size: 25, design: .monospaced))
                .bold()
            Spacer()
        }
        .padding()
        .foregroundColor(Color("LaunchScreenBackGround"))
        .background(Color("BarColor"))
    }
    
    var inputArea: some View {
        // Input Area
        HStack {
            TextField("メッセージを入力", text: $chatTextField)
                .padding()
                .frame(height: 40)
                .background(Color("white_black"))
                .clipShape(Capsule())
                .foregroundColor(.primary)
            Button(action: {
                let message = Message(id: UUID().uuidString, message: chatTextField, isUser: "user")
                chat.append(message)
                let chatText = chatTextField
                chatTextField = ""
                // 新しいメッセージの追加
                messages.append(["role": "user", "content": chatText])
                
                if !chatText.isEmpty {
                    
                    // ChatGPTのAPIにメッセージを送信
                    ChatBotAPIClient().sendMessageChatGPT(messages: messages) { result in
                        if let result = result {
                            messages.append(contentsOf: result)
                            
                            // roleがuserのメッセージを抽出
                            let responseMessage = result.filter { $0["role"] == "assistant" }
                            
                            
                            for massage in responseMessage {
                                if let content = massage["content"] {
                                    // レスポンスで帰ってきたメッセージをchatに追加
                                    let message = Message(id: UUID().uuidString, message: content, isUser: "assistant")
                                    chat.append(message)
                                }
                            }
                        } else {
                            print("error")
                        }
                    }
                }
            }, label: {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .foregroundColor(Color("LaunchScreenBackGround"))
                    .frame(width: 20, height: 20)
                    .padding(.horizontal)
            })
        }
        .padding()
        .foregroundColor(.white)
        .background(Color("BarColor"))
    }
    
}
