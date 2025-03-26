import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    var onDelete: () -> Void // Колбэк для удаления рецепта

    var body: some View {
        ZStack(alignment: .topLeading) {  // Изменили на .topLeading для левого верхнего угла
            VStack {
                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                    AsyncImage(url: URL(string: recipe.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 120)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Color.gray
                                .frame(width: 160, height: 120)
                                .cornerRadius(10)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle()) // Убираем стандартный стиль NavigationLink

                Text(recipe.title)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: 160)
                    .padding(.top, 5)
                    .foregroundColor(.primary)
            }
            .background(Color.white)
            .cornerRadius(12)

            // Кнопка троеточия в левом верхнем углу
            Menu {
                Button(role: .destructive, action: onDelete) {
                    Label("Удалить", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.black) // Черные точки
                    .font(.system(size: 20)) // Размер точки
                    .padding(6)
            }
            .offset(x: 8, y: 8) // Смещение кнопки влево и вверх
        }
    }
}
