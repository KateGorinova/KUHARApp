//
//  CatalogView.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 22.03.25.
//

import SwiftUI

struct CatalogView: View {
    let recipe: Recipe

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
            .offset(x: 8, y: 8) // Смещение кнопки влево и вверх
        }
    }
}
