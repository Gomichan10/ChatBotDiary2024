//
//  ChatView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/10.
//

import SwiftUI



struct ChatView: View {
    
    enum Field: Hashable {
        case inputField
    }
    
    @FocusState private var focusedField: Field?
    
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
        NavigationView {
            VStack (spacing: 0){
                messageArea
                    .overlay (
                        navigationArea
                        
                        ,alignment: .top
                    )
                inputArea
            }
        }
    }
}

#Preview {
    ChatView()
}

extension ChatView {
    
    var messageArea: some View {
        // Message Area
        ScrollViewReader { proxy in
            ScrollView {
                VStack (spacing: 20){
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
            .onTapGesture {
                focusedField = nil
            }
            .onChange(of: chat) {
                withAnimation {
                    if let lastMessage = chat.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    var navigationArea: some View {
        // Navigation Area
        HStack {
            Button(action: {
                
            }, label: {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            Spacer()
                .frame(width: 5)
            Spacer()
            Text("Ai Diary")
                .font(.system(size: 25, design: .monospaced))
                .bold()
            Spacer()
            NavigationLink(destination: CalendarView()) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
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
                .focused($focusedField, equals: .inputField)
            Button(action: {
                
                // キーボードをしまう
                focusedField = nil
                
                if !chatTextField.isEmpty {
                    let message = Message(id: UUID().uuidString, message: chatTextField, isUser: "user")
                    chat.append(message)
                    messages.append(["role": "user", "content": chatTextField])
                    chatTextField = ""
                    
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
                    .foregroundColor(chatTextField.isEmpty ? .gray.opacity(0.4) : Color("LaunchScreenBackGround"))
                    .frame(width: 20, height: 20)
                    .padding(.horizontal)
            })
        }
        .padding()
        .foregroundColor(.white)
        .background(Color("BarColor"))
    }
    
}
