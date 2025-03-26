import SwiftUI

struct ProfileView: View {
    @State private var isAuthViewShow = false
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        VStack {
            ZStack {
                Image("profile_header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 497)
                    .clipped()
                
                Text("KUHAR")
                    .font(.system(size: 75))
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Профиль")
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(String(viewModel.profile.name.prefix(1)))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        )
                    
                    VStack(alignment: .leading) {
                        TextField("Введите ваше имя", text: $viewModel.profile.name)
                            .font(.headline)
                    }
                    Spacer()
                }
            }
            .padding()
            
            Spacer()
            
            // Кнопка выхода
            Button(action: {
                isAuthViewShow.toggle()
            }) {
                Text("Выйти из аккаунта")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding()
            }
            .fullScreenCover(isPresented: $isAuthViewShow, onDismiss: nil) {
                AuthenticationView()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onSubmit {
            viewModel.setProfile()
        }
        .onAppear {
            self.viewModel.getProfile()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(profile: NewUser(id: "", name: "")))
    }
}
