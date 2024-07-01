//
//  MainTabView.swift
//  
//
//  Created by Gomi Kouki on 2024/06/10.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("チャット")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("カレンダー")
                }
        }
        .accentColor(Color("BarColor"))
    }
}

#Preview {
    MainTabView()
}
