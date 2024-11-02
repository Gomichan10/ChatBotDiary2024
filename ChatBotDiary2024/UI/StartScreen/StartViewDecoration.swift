//
//  StartViewDecoration.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/10/31.
//

import SwiftUI


var startViewDecoration: some View {
    GeometryReader { reader in
        ZStack {
            Image("Diary")
                .resizable()
                .scaledToFill()
                .mask(alignment: .top) {
                    LinearGradient(
                        gradient: .init(colors: [.red, .clear]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                }
                .edgesIgnoringSafeArea(.all)
            VStack (){
                Spacer()
                    .frame(height: 50)
                Text("AIと日記を作ろう")
                    .foregroundColor(.white)
                    .font(.system(size: 30.0, design: .default))
                    .bold()
                    .padding(.top, 110)
                Text("いつもの日記をより楽しく楽に")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .position(x: reader.size.width / 2, y: reader.size.height * 0.4)
    }
}
