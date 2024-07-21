//
//  CalendarView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/10.
//

import SwiftUI

struct CalendarView: View {
    
    @State private var date = Date()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack (spacing: 0){
            // Navigation Area
            HStack (alignment: .center){
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                })
                .frame(width: 25, height: 20)
                .padding(.leading, 15)
                
                Spacer()
                
                Text("My Diary")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 25, design: .monospaced))
                    .bold()
                
                Spacer()
                
                Spacer()
                    .frame(width: 40)
            }
            .frame(height: 60)
            .foregroundColor(Color("LaunchScreenBackGround"))
            .background(Color("BarColor"))
            
            
            VStack {
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .datePickerStyle(.graphical)
                .background(Color.white)
                .cornerRadius(15.0)
                .padding()
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background(Color("ChatBackground"))
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    CalendarView()
}
