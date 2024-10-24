//
//  CustomAlertView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/09/07.
//

import SwiftUI

struct SuccsesAlertView: View {
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("日記を追加しました\n追加した日記を確認しますか")
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("BarColor"))
                    .frame(width: 300, height: 100)
                    .font(.custom("Kiwi Maru", size: 20.0))
                    .padding()
                
                Divider()
                    .frame(width: 300)
                    .background(Color.black)
                
                HStack {
                    NavigationLink(destination: CalendarView()) {
                        Text("確認")
                            .bold()
                            .foregroundColor(.black)
                            .frame(width: 100)
                            .padding()
                    }
//                    Divider()？
//                        .frame(height: 60)
//                        .background(Color.black)
//                    
//                    Button(action: {
//                        onCancel()
//                    }, label: {
//                        Text("キャンセル")
//                            .foregroundColor(.white)
//                            .frame(width: 100)
//                            .padding()
//                    })
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

struct FailureAlertView: View {
    var onRetry: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("日記の追加に失敗しました\nもう一度追加してください")
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("BarColor"))
                    .frame(width: 300, height: 100)
                    .font(.custom("Kiwi Maru", size: 20.0))
                    .padding()
                
                Divider()
                    .frame(width: 300)
                    .background(Color.black)
                
                Button(action: {
                    onRetry()
                }, label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .frame(width: 290)
                        .padding()
                })
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

