//
//  Recipe.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 10.03.25.
//

import Foundation

struct Recipe_random: Identifiable {
    let id: Int
    let title: String
    let image: String
    let calories: Int
    let protein: Int
    let fat: Int
    let carbohydrate: Int
}

struct Recipe: Identifiable, Codable {
    let id: Int
    let title: String
    let image: String
    let portions: Int
    let time: Int
    let description: String
    let calories: Int
    let protein: Int
    let fat: Int
    let carbohydrate: Int
    let ingredients: [String: String]
    let instructions: [String]
    
    init(id: Int, title: String, image: String, time: Int, portions: Int, description: String,
         calories: Int, protein: Int, fat: Int, carbohydrate: Int, ingredients: [String: String], instructions: [String]) {
        self.id = id
        self.title = title
        self.image = image
        self.time = time
        self.portions = portions
        self.description = description
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbohydrate = carbohydrate
        self.ingredients = ingredients
        self.instructions = instructions
    }
}
