//
//  RecipeViewModel.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 11.03.25.
//
import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipe: Recipe_random?

    init() {
        recipe = getRecipeOfTheDay()
    }

    func getRecipeOfTheDay() -> Recipe_random? {
        let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdate") as? Date
        let today = Calendar.current.startOfDay(for: Date())
        
        if lastUpdate == nil || lastUpdate != today {
            let recipe = DatabaseManager.shared.fetchRandomRecipe()
            UserDefaults.standard.set(today, forKey: "lastUpdate")
            UserDefaults.standard.set(recipe?.id, forKey: "recipeOfTheDay")
            return recipe
        } else {
            if let id = UserDefaults.standard.object(forKey: "recipeOfTheDay") as? Int {
                return DatabaseManager.shared.fetchRecipeById(id)
            }
        }
        return nil
    }
}
