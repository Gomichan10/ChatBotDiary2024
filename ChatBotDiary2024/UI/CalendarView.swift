//
//  CalendarView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/10.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    
    @State private var date = Date()
    @State private var diaryDates: [Date] = []
    @State var diaryText: String = ""
    @State var selectDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack (spacing: 0){
            // Navigation Area
            navigationArea
            
            // DatePicker Area
            datePickerArea
            
        }
        .onAppear {
            FirestoreAPIClient().fetchDiary { result in
                switch result {
                case .success(let dates):
                    diaryDates = dates
                    // カレンダー再描画
                    NotificationCenter.default.post(name: Notification.Name("CalendarReload"), object: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}

#Preview {
    CalendarView()
}

extension CalendarView {
    
    private var navigationArea: some View {
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
    }
    
    private var datePickerArea: some View {
        GeometryReader { geometry in
            VStack {
                FSCalendarView(diaryDates: $diaryDates, diaryText: $diaryText, selectDate: $selectDate)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.5)
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .background(.white)
                    .cornerRadius(10.0)
                
                diaryArea(geometry: geometry)
            }
            .frame(maxWidth: .infinity ,maxHeight: .infinity)
            .background(Color("ChatBackground"))
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func diaryArea(geometry: GeometryProxy) -> some View {
        
        ScrollView {
            VStack {
                Text(selectDate, formatter: dateFormatter)
                    .font(.custom("Kiwi Maru", size: 20))
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 10)
                Text(diaryText)
                    .font(.custom("Kiwi Maru", size: 15))
                    .foregroundColor(Color("BarColor"))
                    .padding()
                    .underline(color: .gray).opacity(0.5)
            }
        }
        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.4)
        .background(.white)
        .cornerRadius(10.0)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
    
}
