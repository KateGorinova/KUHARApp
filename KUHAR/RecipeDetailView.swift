import SwiftUI

struct RecipeDetailView: View {
    let recipeId: Int
    @State private var recipe: Recipe?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var savedRecipesManager: SavedRecipesManager

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                if let recipe = recipe {
                    AsyncImage(url: URL(string: recipe.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .clipped()
                        } else {
                            Color.gray
                                .frame(height: 300)
                        }
                    }
                    
                    Text(recipe.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    HStack {
                        Text("🍽 \(recipe.portions) порции")
                        Text("⏳ \(recipe.time) мин")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    Divider()
                        .padding(.horizontal)
                    if !recipe.description.isEmpty {
                        HStack(alignment: .top) {
                            Image("icon")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color.yellow)
                                .clipShape(Circle())
                                .padding(.trailing, 8)

                            Text(recipe.description)
                                .font(.body)
                        }
                        .padding(.horizontal)
                        Divider()
                            .padding(.horizontal)
                    }
                    VStack(alignment: .center) {
                        Text("Энергетическая ценность на порцию")
                            .font(.headline)

                        HStack(alignment: .top) {
                            NutrientView(label: "Калории", value: "\(recipe.calories) ккал")
                            NutrientView(label: "Белки", value: "\(recipe.protein) г")
                            NutrientView(label: "Жиры", value: "\(recipe.fat) г")
                            NutrientView(label: "Углеводы", value: "\(recipe.carbohydrate) г")
                            .padding(.top, 1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    Divider()
                        .padding(.horizontal)
                    
                    if !recipe.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ингредиенты:")
                                .font(.headline)
                                .padding(.bottom, 15)
                            ForEach(recipe.ingredients.sorted(by: >), id: \.key) { ingredient, amount in
                                HStack {
                                    Text(ingredient)
                                        .fontWeight(.regular)
                                    Spacer()
                                    Text(amount)
                                        .fontWeight(.thin)
                                }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("Ингредиенты")
                    }
                    Divider()
                        .padding(.horizontal)
                    
                    if !recipe.instructions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Инструкция приготовления:")
                                .font(.headline)
                                .padding(.bottom, 4)
                            ForEach(recipe.instructions.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 4) {
                                    // Разделитель с шагом
                                    Text("Шаг \(index + 1)/\(recipe.instructions.count)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(UIColor.systemOrange.withAlphaComponent(0.2)))
                                        .cornerRadius(8)
                                    
                                    // Текст инструкции
                                    Text(recipe.instructions[index])
                                        .padding([.leading, .trailing])
                                }
                                .background(Color.white)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Button(action: {
                        savedRecipesManager.saveRecipe(recipe)
                    }) {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("Сохранить")
                        }
                        .frame(maxWidth: 200, minHeight: 44)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(70)
                    }
                    .padding(.horizontal)
                } else {
                    ProgressView("Загрузка...")
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            recipe = DatabaseManager.shared.fetchFullRecipeById(recipeId)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                }
            }
        }
    }
}

struct NutrientView: View {
    let label: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RecipeDetailView(recipeId: 4974)
}
