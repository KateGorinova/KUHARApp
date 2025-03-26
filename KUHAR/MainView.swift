import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State private var selectedTab = 3
    var viewModel: MainBarViewModel
    
    init(viewModel: MainBarViewModel) {
        self.viewModel = viewModel

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.orange
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.orange]

        UITabBar.appearance().standardAppearance = appearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                        .frame(height: 25)
                    Text("Главная")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .frame(height: 25)
                    Text("Поиск")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                        .frame(height: 25)
                    Text("Избранное")
                }
                .tag(2)
            
            ProfileView(viewModel: ProfileViewModel(profile: NewUser(id: "", name: "Имя пользователя")))
                .tabItem {
                    Image(systemName: "person")
                        .frame(height: 25)
                    Text("Профиль")
                }
                .tag(3)
        }
    }
}
