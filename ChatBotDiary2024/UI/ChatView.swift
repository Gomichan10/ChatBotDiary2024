//
//  ChatView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/10.
//

import SwiftUI
import SwiftyGif
import FirebaseFirestore
import FirebaseAuth

let chatPrompt: String = """
あなたの役割は、ユーザーと自然な会話を行い、ユーザーの日常の活動についての情報を収集して6回目の返答時に主観的で感情豊かな日記を作成することです。
以下のステップに従ってください：

ユーザーに今日の一日について尋ねる際、必ず疑問形で質問してください。
ユーザーがどこに行ったのかを尋ねる際も、必ず疑問形で質問してください。
ユーザーが誰と一緒にいたのかを尋ねる際も、必ず疑問形で質問してください。
ユーザーが何をしたのかを尋ねる際も、必ず疑問形で質問してください。
ユーザーの感想や特別な出来事について尋ねる際も、必ず疑問形で質問してください。

6回目の返答時に、収集した情報を元にポジティブで感情豊かな日記を必ず作成してユーザーに提示します。
日記は必ず「」の中に記述し、ユーザーが感じたことや、その出来事がどのように影響したかについて主観的な表現を使って記述してください。

会話の例:
AI: こんにちは！今日はどんな一日を過ごしましたか？
ユーザー: 今日は友達と公園に行きました。
AI: 楽しそうですね！どの公園に行ったのですか？
ユーザー: 都立公園に行きました。
AI: 誰と一緒に行ったんですか？
ユーザー: 高校の友達と一緒に行きました。

6回目の返答時:
AI: それでは、今日の一日をまとめてみました。
「今日は友達と都立公園に行って、とても楽しい時間を過ごしました。特に自然の中でリラックスできたことが心に残っています。高校の友達と一緒に笑いながら過ごす時間は、久しぶりに心からの喜びを感じさせてくれました。こんな素敵な一日を過ごせたことに感謝しています。またすぐに会いたいなと思いました。」

日記の作成時には、ユーザーの感情や主観を強調し、日常の出来事がどのようにユーザーに影響を与えたかを記述してください。
"""

struct ChatView: View {
    
    enum Field: Hashable {
        case inputField
    }
    
    @FocusState private var focusedField: Field?
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var chatTextField: String = ""
    @State private var conversationID: String = ""
    @State private var isMessageEnd: Bool = false
    @State private var isLoading = false
    @State private var isShowAlert = false
    @State private var isSuccses = false
    @State private var isSixMessage = false
    @State private var isLastMessage = false
    @State private var chat: [Message] = [Message(id: UUID().uuidString, message: "これから日記を作るよ！どんなことがあったのか教えてね！", isUser: "assistant")]
    
    // プロンプトを設定
    @State var messages = [[
        "role": "system",
        "content": chatPrompt
    ]]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack (spacing: 0){
                    messageArea
                        .overlay (
                            navigationArea
                            
                            ,alignment: .top
                        )
                        .overlay(
                            Group {
                                if isShowAlert {
                                    if isSuccses {
                                        AnyView(
                                            SuccsesAlertView(
                                                onCancel: {
                                                    messages = [[
                                                        "role": "system",
                                                        "content": chatPrompt
                                                    ]]
                                                    chat = [Message(id: UUID().uuidString, message: "これから日記を作るよ！どんなことがあったのか教えてね！", isUser: "assistant")]
                                                    withAnimation { // アニメーションでフェードアウト
                                                        isShowAlert = false
                                                    }
                                                }
                                            )
                                            .opacity(isShowAlert ? 1 : 0)
                                            .animation(.easeInOut(duration: 0.3), value: isShowAlert)
                                        )
                                    } else {
                                        AnyView(
                                            FailureAlertView(
                                                onRetry: {
                                                    isShowAlert = false
                                                }
                                            )
                                        )
                                    }
                                } else {
                                    EmptyView() // アラートが表示されていない場合は空のビューを表示
                                }
                            }
                            , alignment: .center
                        )
                    inputArea
                }
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
                            ZStack {
                                HStack (alignment: .top){
                                    Image("ChatBotIcon")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    VStack {
                                        if chat.isLoading {
                                            GifView(gifName: "Loading.gif", width: 200, height: 128)
                                                .frame(width: 99, height: 99)
                                        } else {
                                            Text(chat.message)
                                                .font(.custom("Kiwi Maru", size: 16.0))
                                                .padding()
                                                .foregroundColor(.primary)
                                        }
                                        if chat.showDiaryButton {
                                            Button {
                                                let diaryText = chat.message
                                                let extractDiaryText = extractString(from: diaryText)
                                                let diary = Diary(date: Date(), diaryText:extractDiaryText!, id: Auth.auth().currentUser!.uid)
                                                
                                                FirestoreAPIClient().saveDiary(diary: diary) { result in
                                                    switch result {
                                                    case true:
                                                        isSuccses = true
                                                        withAnimation { // アニメーションでフェードアウト
                                                            isShowAlert = true
                                                        }
                                                        print("日記に追加しました")
                                                    case false:
                                                        isShowAlert = true
                                                        print("日記に追加できませんでした")
                                                    }
                                                }
                                                
                                            } label: {
                                                Text("日記に追加")
                                            }
                                            .font(.system(size: 18))
                                            .bold()
                                            .foregroundColor(Color("DiaryAddColor"))
                                            .padding()
                                            .onAppear{
                                                // メッセージがラストだったらメッセージを送れないようにする
                                                isLastMessage = true
                                            }
                                        }
                                    }
                                    .background(Color("white_black"))
                                    .cornerRadius(15.0)
                                    
                                    Spacer()
                                }
                                .padding(.bottom)
                            }
                            
                        } else {
                            // ユーザのメッセージだった場合
                            HStack (alignment: .top){
                                Spacer()
                                
                                Text(chat.message)
                                    .font(.custom("Kiwi Maru", size: 16.0))
                                    .padding()
                                    .foregroundColor(Color("white_black"))
                                    .background(.primary)
                                    .cornerRadius(15.0)
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            .padding(.bottom)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 72)
            }
            .frame(maxWidth: .infinity)
            .background(Color("ChatBackground"))
            .onTapGesture {
                focusedField = nil
            }
            .onAppear {
                if let lastMessage = chat.last {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
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
                
                // ロード中のUIを表示
                isLoading = true
                
                // キーボードをしまう
                focusedField = nil
                
                if !chatTextField.isEmpty && !isLastMessage {
                    if messages.count >= 11 {
                        isSixMessage = true
                    }
                    let message = Message(id: UUID().uuidString, message: chatTextField, isUser: "user")
                    chat.append(message)
                    messages.append(["role": "user", "content": chatTextField])
                    chatTextField = ""
                    
                    let loadingMessage = Message(id: UUID().uuidString, message: "", isUser: "assistant", isLoading: true)
                    chat.append(loadingMessage)
                    
                    // ChatGPTのAPIにメッセージを送信
                    ChatBotAPIClient().sendMessageChatGPT(messages: messages, isSixMessage: isSixMessage) { result in
                        if let result = result {
                            messages.append(contentsOf: result)
                            print(messages)
                            
                            // roleがuserのメッセージを抽出
                            let responseMessage = result.filter { $0["role"] == "assistant" }
                            
                            for (_ , massage) in responseMessage.enumerated() {
                                if let content = massage["content"] {
                                    // レスポンスで帰ってきたメッセージをchatに追加
                                    var message = Message(id: UUID().uuidString, message: content, isUser: "assistant")
                                    // 日記を作成したメッセージにボタンを追加
                                    if checkLastMessage(message: content) {
                                        message.showDiaryButton = true
                                    }
                                    chat.removeLast()
                                    chat.append(message)
                                    isLoading = false
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
                    .foregroundColor(chatTextField.isEmpty || isLastMessage ? .gray.opacity(0.4) : Color("LaunchScreenBackGround"))
                    .frame(width: 20, height: 20)
                    .padding(.horizontal)
            })
        }
        .padding()
        .foregroundColor(.white)
        .background(Color("BarColor"))
    }
    
}

