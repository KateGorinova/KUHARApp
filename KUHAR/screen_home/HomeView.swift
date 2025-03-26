import SwiftUI

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let recipe = viewModel.recipe { // Убрали $
                    NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                        VStack {
                            AsyncImage(url: URL(string: recipe.image)) { image in // Убрали "?"
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray.frame(width: 420, height: 600)
                            }
                            .frame(width: 420, height: 600)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Рецепт дня")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text(recipe.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    NutrientView(label: "Ккал", value: recipe.calories)
                                    NutrientView(label: "Белки", value: Int(recipe.protein))
                                    NutrientView(label: "Жиры", value: Int(recipe.fat))
                                    NutrientView(label: "Углеводы", value: Int(recipe.carbohydrate))
                                }
                            }
                            .padding()
                            .background(Color(.systemOrange).opacity(0.2))
                            .cornerRadius(20)
                            .padding()
                            .offset(y: -15)
                        }
                        .edgesIgnoringSafeArea(.top)
                    }
                    .edgesIgnoringSafeArea(.top)
                    .buttonStyle(PlainButtonStyle()) // Убрали эффект нажатия
                } else {
                    Text("Загрузка...")
                }
            }
            .onAppear {
                viewModel.recipe = viewModel.getRecipeOfTheDay()
            }
        }
    }
    struct NutrientView: View {
        let label: String
        let value: Int
        
        var body: some View {
            VStack {
                Text("\(value)")
                    .font(.headline)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
}
