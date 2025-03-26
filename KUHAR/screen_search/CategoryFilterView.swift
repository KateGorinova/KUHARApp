//
//  CategoryFilterView.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 23.03.25.
//

import SwiftUI

struct CategoryFilterView: View {
    let categories = ["Завтраки", "Закуски", "Напитки", "Основные блюда",
                      "Паста и пицца", "Выпечка и десерты", "Заготовки",
                      "Сэндвичи", "Ризотто", "Соусы", "Салаты", "Супы"]
    
    @Binding var selectedCategory: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Категории")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category ? nil : category
                    }) {
                        VStack {
                            Image(systemName: categoryIcon(category)) // Добавляем иконку (функция ниже)
                                .font(.system(size: 24))
                            
                            Text(category)
                                .font(.footnote)
                        }
                        .frame(width: 80, height: 60)
                        .background(selectedCategory == category ? Color.orange.opacity(0.3) : Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedCategory == category ? Color.orange : Color.clear, lineWidth: 2)
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// Функция подбирает иконки для категорий (примерно)
    func categoryIcon(_ category: String) -> String {
        switch category {
        case "Завтраки": return "cup.and.saucer.fill"
        case "Закуски": return "skewer.fill"
        case "Напитки": return "wineglass.fill"
        case "Основные блюда": return "fork.knife"
        case "Паста и пицца": return "pizza.fill"
        case "Выпечка и десерты": return "birthday.cake.fill"
        case "Заготовки": return "jar.fill"
        case "Сэндвичи": return "takeoutbag.and.cup.and.straw.fill"
        case "Ризотто": return "leaf.fill"
        case "Соусы": return "mug.fill"
        case "Салаты": return "leaf.circle.fill"
        case "Супы": return "bowl.fill"
        default: return "questionmark.circle"
        }
    }
}
