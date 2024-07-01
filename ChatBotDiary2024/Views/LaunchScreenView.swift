//
//  LaunchScreenView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/11.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State private var showFirstScreen: Bool = false
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Image("AiDiaryLaunchScreen")
                .resizable()
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ContentView()
            }
        }
        .background(Color(red: 255/255, green: 238/255, blue: 214/255))
        .fullScreenCover(isPresented: $showFirstScreen) {
           
        }
    }
}

#Preview {
    LaunchScreenView()
}
