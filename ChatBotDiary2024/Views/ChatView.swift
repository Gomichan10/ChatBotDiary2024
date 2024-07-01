//
//  ChatView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/10.
//

import SwiftUI



struct ChatView: View {
    
    @State var chatTextField: String = ""
    
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
                ForEach(0..<15) { _ in
                    HStack (alignment: .top){
                        Image("ChatBotIcon")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text("こんにちは")
                            .padding()
                            .foregroundColor(.primary)
                            .background(Color("white_black"))
                            .cornerRadius(15.0)
                            
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 72)
            .padding(.bottom, 20)
        }
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
            Button(action: {
                ChatBotAPIClient().sendMessageToChatbot(message: chatTextField) { result in
                    switch result {
                    case true:
                        print("Success")
                    case false:
                        print("failure")
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
