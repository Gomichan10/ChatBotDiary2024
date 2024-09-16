//
//  CustomAlertView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/09/07.
//

import SwiftUI

struct CustomAlertView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("日記を追加しました\n追加した日記を確認しますか")
                    // .foregroundColor(Color("LaunchScreenBackGround"))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 100)
                    .font(.custom("Kiwi Maru", size: 20.0))
                    .padding()
                
//                Text("追加した日記を確認しますか")
//                    .foregroundColor(.white)
//                    .font(.custom("Kaisei HarunoUmi", size: 18.0))
//                    .padding(.top, 10)
//                    .padding(.bottom, 40)
                
                Divider()
                    .frame(width: 300)
                    .background(Color.black)
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("OK")
                            .frame(width: 100)
                            .padding()
                    })
                    
                    
                    Divider()
                        .frame(height: 60)
                        .background(Color.black)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("キャンセル")
                            .frame(width: 100)
                            .padding()
                    })
                }
            }
        }
        .frame(width: 300, height: 190)
        .background(Color("ChatBackground"))
        .cornerRadius(15.0)
        .overlay(
            RoundedRectangle(cornerRadius: 15.0)
                .stroke(Color("BarColor"), lineWidth: 3.0)
        )
        
    }
}

#Preview {
    CustomAlertView()
}
