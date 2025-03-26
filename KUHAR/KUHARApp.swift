//
//  KUHARApp.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 9.03.25.
//

import SwiftUI
import Firebase

@main
struct KUHARApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject private var savedRecipesManager = SavedRecipesManager()
    
    init() {
            let _ = DatabaseManager.shared
        }
    var body: some Scene {
        WindowGroup {
            if let user = AuthService.shared.currentUser{
                let viewModel = MainBarViewModel(user: user)
                MainView(viewModel: viewModel)
                    .environmentObject(savedRecipesManager)
            } else{
                AuthenticationView()
                    .environmentObject(savedRecipesManager)
            }
        }
    }
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            print("OK")
            return true
        }
        
    }
}
