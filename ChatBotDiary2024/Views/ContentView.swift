//
//  ContentView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/05/24.
//

import SwiftUI

struct ContentView: View {
    
    enum ButtonState {
        case normal
        case loading
        case completed
        case error
    }
    
    enum AlertState {
        case email
        case pass
        case error
    }
    
    struct ColorManager {
        static let baseColor = Color("white_black")
    }
    
    @State var sheet: Bool = false
    @State var email: String = ""
    @State var pass: String = ""
    @State var buttonState: ButtonState = .normal
    @State var alertState: AlertState?
    @State var isLarge: Bool = false
    @State var showAlert: Bool = false
    
    
    var body: some View {
        //背景とタイトル
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
                Text("AIと日記を作ろう")
                    .foregroundColor(.white)
                    .font(.system(size: 30.0, design: .default))
                    .bold()
                    .padding(.top, 110)
                Text("いつもの日記をより楽しく楽に")
                    .foregroundColor(.white)
                Spacer()
                loginButton
                signInButton
            }
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    //ログインボタン
    var loginButton: some View {
        VStack {
            Button(
                action: {},
                label: {
                    HStack {
                        Image("GoogleIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                            .padding(.leading, 15)
                        Spacer()
                        Text("Googleでログイン")
                            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.6))
                            .bold()
                            .padding(.trailing, 100)
                    }
                })
            .frame(width: 350, height: 55)
            .background(Color.white)
            .cornerRadius(.infinity)
            .shadow(radius: 15)
            Button(
                action: {},
                label: {
                    HStack {
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 27, height: 20)
                            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.65))
                            .padding(.leading, 15)
                        Spacer()
                        Text("メールでログイン")
                            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.65))
                            .bold()
                            .padding(.trailing, 105)
                    }
                })
            .frame(width: 350, height: 55)
            .background(Color.white)
            .cornerRadius(.infinity)
            .shadow(radius: 15)
        }
    }
    
    //サインインボタン
    var signInButton: some View {
        Button(
            action: {
                sheet.toggle()
            },
            label: {
                Text("サインアップ")
                    .foregroundColor(ColorManager.baseColor.opacity(0.65))
                    .bold()
            })
        .padding()
        .sheet(isPresented: $sheet) {
            NavigationStack {
                VStack (spacing: 20){
                    
                    TextField("メールアドレスを入力", text: $email)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.07))
                        .cornerRadius(6)
                    
                    SecureField("パスワードを入力", text: $pass)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.07))
                        .cornerRadius(6)
                    
                    Button {
                        switch buttonState {
                        case .normal:
                            buttonState = .loading
                            UIApplication.shared.endEditing()
                            FirestoreAPIClient().searchUser(email: email) { result in
                                
                                switch result {
                                case true:
                                    if Validation().isValidEmail(email) {
                                        if Validation().isValidPassword(pass) {
                                            UserAPIClient().createUser(email: email, password: pass) { result in
                                                switch result {
                                                case true:
                                                    print("Success")
                                                    buttonState = .completed
                                                case false:
                                                    print("Failure")
                                                }
                                            }
                                        } else {
                                            alertState = .pass
                                            showAlert = true
                                            buttonState = .normal
                                        }
                                    } else {
                                        alertState = .email
                                        showAlert = true
                                        buttonState = .normal
                                    }
                                case false:
                                    buttonState = .error
                                    alertState = .error
                                    showAlert = true
                                }
                            }
                            
                        case.loading:
                            break
                        case .completed:
                            break
                        case .error:
                            break
                        }
                    } label: {
                        switch buttonState {
                        case .normal:
                            Image(systemName: "arrow.right.circle")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray)
                                .padding(.top, 50)
                        case .loading:
                            ZStack {
                                Circle()
                                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 6))
                                    .frame(width: 60, height: 60)
                                ProgressView()
                                    .scaleEffect(x: 2, y: 2)
                            }
                            .padding(.top, 50)
                        case .completed:
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.green)
                                .padding(.top, 50)
                        case .error:
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.red)
                                .padding(.top, 50)
                        }
                    }
                }
                .navigationTitle("新規アカウント作成")
                .alert(isPresented: $showAlert) {
                    switch alertState {
                    case .email:
                        return Alert(title: Text("正常なメールアドレスが入力されていません"), message: Text("もう一度メールアドレスを入力し直してください"), dismissButton: .default(Text("OK")))
                    case .pass:
                        return Alert(title: Text("正しいパスワードを入力してください"), message: Text ("最低1文字の小文字または大文字を含み、最低1文字以上の数字を含む10文字以上のパスワードを入力してください"), dismissButton: .default(Text("OK")))
                    case .error:
                        return Alert(title: Text("すでに登録されているメールアドレスです"), message: Text ("入力されたメールアドレスはすでに登録されています。もう一度入力し直してください。"), dismissButton:.default(Text("OK"), action: { buttonState = .normal }))
                    case .none:
                        return Alert(title: Text("エラー"), message: Text("エラーが発生しました"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

