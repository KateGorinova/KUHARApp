import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @State private var isAuth = true
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isProfileViewShow = false
    @State private var isShowAlert = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack() {
            Spacer()
            
            Text("KUHAR")
                .font(.system(size: 56, weight: .regular))
                .padding(.top, 30)
            
            Text(isAuth ? "Войдите в свой аккаунт" : "Создайте аккаунт")
                .font(.headline)
                .padding(.top, 40)
            
            Text(isAuth ? "Введите адрес электронной почты и пароль" : "Введите email, чтобы зарегистрироваться")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 1)
            
            TextField("Email", text: $email)
                .padding(.horizontal)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .frame(height: 60)
                .padding(.leading, 15)
                .padding(.trailing, 15)
            
            SecureField("Введите пароль", text: $password)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(height: 53)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding(.top, 1)
                .padding(.leading, 15)
                .padding(.trailing, 15)
            
            if !isAuth {
                SecureField("Повторите пароль", text: $confirmPassword)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(height: 53)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .padding(.top, 1)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
            }
            
            Button(action: {
                if isAuth {
                    print("Авторизация")
                    AuthService.shared.signIn(email: self.email, password: self.password) { result in
                        switch result {
                        case .success(_):
                            isProfileViewShow.toggle()
                        case .failure(_):
                            alertMessage = "Ошибка авторизации!"
                            self.isShowAlert.toggle()
                        }
                    }
                } else {
                    print("Регистрация")
                    guard password == confirmPassword else {
                        self.alertMessage = "Пароли не совпадают!"
                        self.isShowAlert.toggle()
                        return
                    }
                    AuthService.shared.signUp(email: self.email, password: self.password) { result in
                        switch result {
                        case .success(_):
                            alertMessage = "Регистрация прошла успешно!"
                            self.isShowAlert.toggle()
                            self.email = ""
                            self.password = ""
                            self.confirmPassword = ""
                            self.isAuth.toggle()
                        case .failure(_):
                            alertMessage = "Ошибка при регистрации!"
                            self.isShowAlert.toggle()
                        }
                    }
                }
            }) {
                Text("Продолжить")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 11)
            }
            
            Text("или")
                .foregroundColor(.gray)
            
            Button(action: {
                isAuth.toggle()
            }) {
                Text(isAuth ? "Зарегистрироваться" : "Войти")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
            Text("Нажимая «Продолжить», вы соглашаетесь с нашими Условиями обслуживания и Политикой конфиденциальности.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
        }
        .padding()
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: $isProfileViewShow) {
            if let currentUser = AuthService.shared.currentUser {
                let mainBarViewModel = MainBarViewModel(user: currentUser)
                MainView(viewModel: mainBarViewModel)
            } else {
                Text("Ошибка: текущий пользователь не найден")
            }
        }
        .alert(alertMessage, isPresented: $isShowAlert) {
            Button {} label: {
                Text("OK")
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
