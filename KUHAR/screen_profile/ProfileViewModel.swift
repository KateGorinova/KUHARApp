import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: NewUser
    
    init(profile: NewUser) {
        self.profile = profile
    }
    
    func setProfile() {
        DatabaseService.shared.setProfile(user: self.profile) { result in
            switch result {
            case .success(let user):
                print("Profile updated: \(user.name)")
            case .failure(let error):
                print("Ошибка при обновлении профиля: \(error.localizedDescription)")
            }
        }
    }
    
    func getProfile() {
        DatabaseService.shared.getProfile { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.profile = user
                }
            case .failure(let error):
                print("Ошибка при получении профиля: \(error.localizedDescription)")
            }
        }
    }
}
