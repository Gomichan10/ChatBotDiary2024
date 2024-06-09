//
//  ContentView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/05/24.
//

import SwiftUI

struct ContentView: View {
    
    enum LoginButtonState {
        case normal
        case loading
        case completed
        case error
    }
    
    enum SigninButtonState {
        case normal
        case loading
        case completed
        case error
    }
    
    enum AlertSigninState {
        case email
        case pass
        case error
    }
    
    struct ColorManager {
        static let baseColor = Color("white_black")
    }
    
    @State var signinSheet: Bool = false
    @State var loginSheet: Bool = false
    @State var loginEmail: String = ""
    @State var loginPass : String = ""
    @State var signinEmail: String = ""
    @State var signinPass: String = ""
    @State var loginButtonState: LoginButtonState = .normal
    @State var signinButtonState: SigninButtonState = .normal
    @State var alertSigninState: AlertSigninState?
    @State var isLarge: Bool = false
    @State var showLoginAlert: Bool = false
    @State var showSigninAlert: Bool = false
    
    
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
                googleButton
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
    
    //Googleログインボタン
    var googleButton: some View {
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
    }
    
    //ログインボタン
    var loginButton: some View {
        Button(
            action: {
                loginSheet.toggle()
            },
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
        .sheet(isPresented: $loginSheet) {
            NavigationStack {
                VStack (spacing: 20){
                    TextField("メールアドレスを入力", text: $loginEmail)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.07))
                        .cornerRadius(6)
                    
                    SecureField("パスワードを入力", text: $loginPass)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.07))
                        .cornerRadius(6)
                    
                    Button {
                        switch loginButtonState {
                        case .normal:
                            loginButtonState = .loading
                            UIApplication.shared.endEditing()
                            UserAPIClient().loginUser(email: loginEmail, password: loginPass) { result in
                                switch result {
                                case true:
                                    loginButtonState = .completed
                                case false:
                                    loginButtonState = .error
                                    showLoginAlert.toggle()
                                }
                            }
                        case .loading:
                            break
                        case .completed:
                            break
                        case .error:
                            break
                        }
                        
                    } label: {
                        switch loginButtonState {
                        case .normal:
                            normalButton
                        case .loading:
                            loadingButton
                        case .completed:
                            completedButton
                        case .error:
                            errorButton
                        }
                    }
                }
                .navigationTitle("ログイン")
                .alert(isPresented: $showLoginAlert) {
                    return Alert(title: Text("メールアドレスまたはパスワードが正しくありません"), message: Text("メールアドレスまたはパスワードが正しくありません。もう一度入力し直してください。"), dismissButton: .default(Text("OK"), action: {loginButtonState = .normal}))
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    //サインインボタン
    var signInButton: some View {
        Button(
            action: {
                signinSheet.toggle()
            },
            label: {
                Text("サインアップ")
                    .foregroundColor(ColorManager.baseColor.opacity(0.65))
                    .bold()
            })
        .padding()
        .sheet(isPresented: $signinSheet) {
            NavigationStack {
                VStack (spacing: 20){
                    
                    TextField("メールアドレスを入力", text: $signinEmail)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.07))
                        .cornerRadius(6)
                    
                    SecureField("パスワードを入力", text: $signinPass)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.07))
                        .cornerRadius(6)
                    
                    Button {
                        switch signinButtonState {
                        case .normal:
                            signinButtonState = .loading
                            UIApplication.shared.endEditing()
                            FirestoreAPIClient().searchUser(email: signinEmail) { result in
                                
                                switch result {
                                case true:
                                    if Validation().isValidEmail(signinEmail) {
                                        if Validation().isValidPassword(signinPass) {
                                            UserAPIClient().createUser(email: signinEmail, password: signinPass) { result in
                                                switch result {
                                                case true:
                                                    signinButtonState = .completed
                                                case false:
                                                    print("Failure")
                                                }
                                            }
                                        } else {
                                            alertSigninState = .pass
                                            showSigninAlert = true
                                            signinButtonState = .normal
                                        }
                                    } else {
                                        alertSigninState = .email
                                        showSigninAlert = true
                                        signinButtonState = .normal
                                    }
                                case false:
                                    signinButtonState = .error
                                    alertSigninState = .error
                                    showSigninAlert = true
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
                        switch signinButtonState {
                        case .normal:
                            normalButton
                        case .loading:
                            loadingButton
                        case .completed:
                            completedButton
                        case .error:
                            errorButton
                        }
                    }
                }
                .navigationTitle("新規アカウント作成")
                .alert(isPresented: $showSigninAlert) {
                    switch alertSigninState {
                    case .email:
                        return Alert(title: Text("正常なメールアドレスが入力されていません"), message: Text("もう一度メールアドレスを入力し直してください"), dismissButton: .default(Text("OK")))
                    case .pass:
                        return Alert(title: Text("正しいパスワードを入力してください"), message: Text ("最低1文字の小文字または大文字を含み、最低1文字以上の数字を含む10文字以上のパスワードを入力してください"), dismissButton: .default(Text("OK")))
                    case .error:
                        return Alert(title: Text("すでに登録されているメールアドレスです"), message: Text ("入力されたメールアドレスはすでに登録されています。もう一度入力し直してください。"), dismissButton:.default(Text("OK"), action: { signinButtonState = .normal }))
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

