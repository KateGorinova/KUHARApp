import SwiftUI

struct SavedRecipesView: View {
    @EnvironmentObject var savedRecipesManager: SavedRecipesManager
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRecipe: Recipe?
    @State private var showDeleteAlert = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .padding(.top, 20)
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                    }
                    Text("Избранное")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(savedRecipesManager.savedRecipes) { recipe in
                            RecipeCardView(recipe: recipe) {
                                selectedRecipe = recipe
                                showDeleteAlert = true
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Удалить рецепт?", isPresented: $showDeleteAlert) {
            Button("Удалить", role: .destructive) {
                if let recipeToDelete = selectedRecipe {
                    savedRecipesManager.removeRecipe(recipeToDelete)
                }
            }
            Button("Отмена", role: .cancel) {}
        }
        .onAppear {
            savedRecipesManager.loadRecipes()
        }
    }
}
