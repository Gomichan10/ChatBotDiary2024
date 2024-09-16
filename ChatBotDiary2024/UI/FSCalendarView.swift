import SwiftUI
import FSCalendar

struct FSCalendarView: UIViewControllerRepresentable {
    
    
    // 日付が登録されている配列をバインディング
    @Binding var diaryDates: [Date]
    // 日記を格納する変数
    @Binding var diaryText: String
    // 選択された日付を格納する変数
    @Binding var selectDate: Date
    // 各曜日のラベルを配列で定義
    private let week: [String] = ["日","月","火","水","木","金","土"]
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: FSCalendarView
        
        init(parent: FSCalendarView) {
            self.parent = parent
        }
        
        // 日記が登録されている日付だったら丸印をつけるメソッド
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            let circleImage = UIImage(systemName: "circle.fill")?.withTintColor(.brown)
            
            let newSize = CGSize(width: 12.0, height: 12.0)
            
            let renderer = UIGraphicsImageRenderer(size: newSize)
            let resizedImage = renderer.image { _ in
                circleImage?.draw(in: CGRect(origin: .zero, size: newSize))
            }
            
            return parent.diaryDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? resizedImage : nil
        }
        
        // 選択された日付に日記が登録されていたら日記内容を返すメソッド
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            
            // 選択された日付に対応する日記を検索
            if let diaryDate = self.parent.diaryDates.first(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                print(diaryDate)
                FirestoreAPIClient().getDiary(date: diaryDate) { result in
                    switch result {
                    case .success(let diary):
                        print(diary)
                        self.parent.diaryText = diary.diaryText
                        self.parent.selectDate = diary.date
                    case .failure(let error):
                        print(error)
                    }
                }
            } 
            
        }
    }
    
    // Coordinatorのインスタンスを作成
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // カレンダーの各設定したのちにViewに追加
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.appearance.headerDateFormat = "YYYY年MM月"
        calendar.appearance.headerTitleColor = UIColor.brown
        calendar.appearance.selectionColor = .brown
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.todayColor = .black
        calendar.appearance.titleTodayColor = .white
        calendar.allowsMultipleSelection = false
        
        for i in 0..<7 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = week[i]
            
            if i == 0 {
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.red
            } else if i == 6 {
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.blue
            } else {
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.black
            }
        }
        
        viewController.view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            calendar.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        
        NotificationCenter.default.addObserver(forName: Notification.Name("CalendarReload"), object: nil, queue: .main) { _ in
            calendar.reloadData()
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let calendar = uiViewController.view.subviews.first as? FSCalendar {
            print("Reloading calendar data")
            calendar.reloadData()
        }
    }
    
}

