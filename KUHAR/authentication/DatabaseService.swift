import Foundation
import FirebaseFirestore

class DatabaseService {
    
    static let shared = DatabaseService()
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private init() { }
    
    func setProfile(user: NewUser, completion: @escaping (Result<NewUser, Error>) -> ()) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func getProfile(completion: @escaping (Result<NewUser, Error>) -> ()) {
        guard let currentUser = AuthService.shared.currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"])))
            return
        }
        
        usersRef.document(currentUser.uid).getDocument { docSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snap = docSnapshot, snap.exists, let data = snap.data(),
                  let userName = data["name"] as? String,
                  let id = data["id"] as? String else {
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found or malformed"])))
                return
            }
            
            let user = NewUser(id: id, name: userName)
            completion(.success(user))
        }
    }
    func saveFavoriteRecipe(_ recipe: Recipe, completion: @escaping (Error?) -> Void) {
            guard let currentUser = AuthService.shared.currentUser else {
                completion(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
                return
            }
            
            let recipeData: [String: Any] = [
                "id": recipe.id,
                "title": recipe.title,
                "image": recipe.image,
                "portions": recipe.portions,
                "time": recipe.time,
                "description": recipe.description,
                "calories": recipe.calories,
                "protein": recipe.protein,
                "fat": recipe.fat,
                "carbohydrate": recipe.carbohydrate,
                "ingredients": recipe.ingredients,
                "instructions": recipe.instructions
            ]
            
            usersRef.document(currentUser.uid).collection("favorites").document(String(recipe.id)).setData(recipeData) { error in
                completion(error)
            }
        }
        func removeFavoriteRecipe(_ recipeId: String, completion: @escaping (Error?) -> Void) {
            guard let currentUser = AuthService.shared.currentUser else {
                completion(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
                return
            }
            
            usersRef.document(currentUser.uid).collection("favorites").document(recipeId).delete { error in
                completion(error)
            }
        }

        func getFavoriteRecipes(completion: @escaping ([Recipe]?, Error?) -> Void) {
            guard let currentUser = AuthService.shared.currentUser else {
                completion(nil, NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
                return
            }
            
            usersRef.document(currentUser.uid).collection("favorites").getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([], nil)
                    return
                }
                
                let recipes: [Recipe] = documents.compactMap { doc in
                    let data = doc.data()
                    
                    guard let id = data["id"] as? Int,
                          let title = data["title"] as? String,
                          let image = data["image"] as? String,
                          let portions = data["portions"] as? Int,
                          let time = data["time"] as? Int,
                          let description = data["description"] as? String,
                          let calories = data["calories"] as? Int,
                          let protein = data["protein"] as? Int,
                          let fat = data["fat"] as? Int,
                          let carbohydrate = data["carbohydrate"] as? Int,
                          let ingredients = data["ingredients"] as? [String: String],
                          let instructions = data["instructions"] as? [String]
                    else {
                        return nil
                    }
                    
                    return Recipe(id: id, title: title, image: image, time: time, portions: portions, description: description,
                                  calories: calories, protein: protein, fat: fat, carbohydrate: carbohydrate, ingredients: ingredients, instructions: instructions)
                }
                
                completion(recipes, nil)
            }
        }
}
