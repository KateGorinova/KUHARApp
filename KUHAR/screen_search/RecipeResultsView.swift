//
//  RecipeResultsView.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 22.03.25.
//

import SwiftUI
struct RecipeResultsView: View {
    let recipes: [Recipe]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(recipes, id: \ .id) { recipe in
                    CatalogView(recipe: recipe)
                }
            }
            .padding()
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
