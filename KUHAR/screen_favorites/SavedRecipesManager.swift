import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class SavedRecipesManager: ObservableObject {
    @Published var savedRecipes: [Recipe] = []
    
    init() {
        loadRecipes()
    }
    
    func saveRecipe(_ recipe: Recipe) {
        DatabaseService.shared.saveFavoriteRecipe(recipe) { error in
            if let error = error {
                print("Error saving recipe: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.savedRecipes.append(recipe)
                }
            }
        }
    }
    
    func removeRecipe(_ recipe: Recipe) {
        DatabaseService.shared.removeFavoriteRecipe(String(recipe.id)) { error in
            if let error = error {
                print("Error removing recipe: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.savedRecipes.removeAll { $0.id == recipe.id }
                }
            }
        }
    }
    
    func loadRecipes() {
        DatabaseService.shared.getFavoriteRecipes { recipes, error in
            if let error = error {
                print("Error loading recipes: \(error.localizedDescription)")
            } else if let recipes = recipes {
                DispatchQueue.main.async {
                    self.savedRecipes = recipes
                }
            }
        }
    }
}
