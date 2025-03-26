// DatabaseManager.swift
// KUHAR
//
// Created by Екатерина Горинова on 11.03.25.
//
import SQLite3
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        openDatabase()
    }
    func openDatabase() {
        if let dbPath = getDatabasePath() {
            if sqlite3_open(dbPath, &db) != SQLITE_OK {
                print("Ошибка открытия базы данных: \(String(cString: sqlite3_errmsg(db)))")
            } else {
                print("База данных успешно открыта")
            }
        }
    }
    
    func getDatabasePath() -> String? {
        let fileManager = FileManager.default
        let folderPath = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let destinationURL = folderPath.appendingPathComponent("recipes.db")
        
        if !fileManager.fileExists(atPath: destinationURL.path) {
            if let sourcePath = Bundle.main.path(forResource: "recipes", ofType: "db") {
                do {
                    try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
                    try fileManager.copyItem(atPath: sourcePath, toPath: destinationURL.path)
                    print("✅ База данных успешно скопирована в \(destinationURL.path)")
                } catch {
                    print("❌ Ошибка копирования базы данных: \(error.localizedDescription)")
                    return nil
                }
            } else {
                print("❌ Файл базы данных не найден в Bundle")
                return nil
            }
        }
        return destinationURL.path
    }

    func fetchRandomRecipe() -> Recipe_random? {
        let query = "SELECT * FROM recipes ORDER BY RANDOM() LIMIT 1"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            print("🔍 SQL-запрос выполнен успешно")
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                print("✅ Найден рецепт: \(title) (ID: \(id))")
                
                let image = String(cString: sqlite3_column_text(statement, 2))
                let calories = Int(sqlite3_column_int(statement, 6))
                let protein = Int(sqlite3_column_int(statement, 7))
                let fat = Int(sqlite3_column_int(statement, 8))
                let carbohydrate = Int(sqlite3_column_int(statement, 9))
                
                sqlite3_finalize(statement)
                return Recipe_random(id: id, title: title, image: image, calories: calories, protein: protein, fat: fat, carbohydrate: carbohydrate)
            }
        } else {
            print("❌ Ошибка выполнения SQL-запроса")
        }
        sqlite3_finalize(statement)
        print("⚠️ Нет данных в базе")
        return nil
    }
    
    
    func fetchRecipeById(_ id: Int) -> Recipe_random? {
        let query = "SELECT * FROM recipes WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let image = String(cString: sqlite3_column_text(statement, 2))
                let calories = Int(sqlite3_column_int(statement, 6))
                let protein = Int(sqlite3_column_int(statement, 7))
                let fat = Int(sqlite3_column_int(statement, 8))
                let carbohydrate = Int(sqlite3_column_int(statement, 9))
                
                sqlite3_finalize(statement)
                return Recipe_random(id: id, title: title, image: image, calories: calories, protein: protein, fat: fat, carbohydrate: carbohydrate)
            }
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    func fetchFullRecipeById(_ id: Int) -> Recipe? {
        let query = "SELECT * FROM recipes WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let image = String(cString: sqlite3_column_text(statement, 2))
                let time = Int(sqlite3_column_int(statement, 3))
                let portions = Int(sqlite3_column_int(statement, 4))
    
                let descriptionPointer = sqlite3_column_text(statement, 5)
                let description = descriptionPointer != nil ? String(cString: descriptionPointer!) : ""
                
                let calories = Int(sqlite3_column_int(statement, 6))
                let protein = Int(sqlite3_column_int(statement, 7))
                let fat = Int(sqlite3_column_int(statement, 8))
                let carbohydrate = Int(sqlite3_column_int(statement, 9))
                
                let ingredientsText = String(cString: sqlite3_column_text(statement, 10))
                let jsonFormattedIngredientsText = ingredientsText.replacingOccurrences(of: "'", with: "\"")
                let ingredientsData = jsonFormattedIngredientsText.data(using: .utf8)!
                let ingredients = try? JSONSerialization.jsonObject(with: ingredientsData, options: []) as? [String: String] ?? [:]
                
                let instructionsText = String(cString: sqlite3_column_text(statement, 11))
                let jsonFormattedInstructionsText = instructionsText.replacingOccurrences(of: "'", with: "\"")
                let instructionsData = jsonFormattedInstructionsText.data(using: .utf8)!
                let instructions = try? JSONSerialization.jsonObject(with: instructionsData, options: []) as? [String] ?? []
                
                sqlite3_finalize(statement)
                
                return Recipe(
                    id: id, title: title, image: image, time: time, portions: portions,
                    description: description, calories: calories, protein: protein,
                    fat: fat, carbohydrate: carbohydrate, ingredients: ingredients ?? [:],
                    instructions: instructions ?? []
                )
            }
        }
        sqlite3_finalize(statement)
        return nil
    }
    func fetchRecipesByTitle(_ keyword: String) -> [Recipe] {
        let query = "SELECT * FROM recipes WHERE LOWER(title) LIKE LOWER(?)"
        var statement: OpaquePointer?
        var recipes: [Recipe] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            let likeKeyword = "%\(keyword)%"
            print(likeKeyword)
            sqlite3_bind_text(statement, 1, likeKeyword, -1, unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self))
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let image = String(cString: sqlite3_column_text(statement, 2))
                let time = Int(sqlite3_column_int(statement, 3))
                let portions = Int(sqlite3_column_int(statement, 4))

                let descriptionPointer = sqlite3_column_text(statement, 5)
                let description = descriptionPointer != nil ? String(cString: descriptionPointer!) : ""
                
                let calories = Int(sqlite3_column_int(statement, 6))
                let protein = Int(sqlite3_column_int(statement, 7))
                let fat = Int(sqlite3_column_int(statement, 8))
                let carbohydrate = Int(sqlite3_column_int(statement, 9))
                
                let ingredientsText = String(cString: sqlite3_column_text(statement, 10))
                let jsonFormattedIngredientsText = ingredientsText.replacingOccurrences(of: "'", with: "\"")
                let ingredientsData = jsonFormattedIngredientsText.data(using: .utf8)!
                let ingredients = try? JSONSerialization.jsonObject(with: ingredientsData, options: []) as? [String: String] ?? [:]
                
                let instructionsText = String(cString: sqlite3_column_text(statement, 11))
                let jsonFormattedInstructionsText = instructionsText.replacingOccurrences(of: "'", with: "\"")
                let instructionsData = jsonFormattedInstructionsText.data(using: .utf8)!
                let instructions = try? JSONSerialization.jsonObject(with: instructionsData, options: []) as? [String] ?? []
                
                let recipe = Recipe(
                    id: id, title: title, image: image, time: time, portions: portions,
                    description: description, calories: calories, protein: protein,
                    fat: fat, carbohydrate: carbohydrate, ingredients: ingredients ?? [:],
                    instructions: instructions ?? []
                )
                recipes.append(recipe)
            }
        } else {
            print("Error preparing statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(statement)
        return recipes
    }
    func fetchRecipesByFilters(title: String?, category: String?, diet: String?, cuisine: String?, sorting: String?) -> [Recipe] {
        var query = "SELECT * FROM recipes WHERE 1=1"
        var parameters: [String] = []
        var statement: OpaquePointer?

        if let title = title, !title.isEmpty {
            query += " AND LOWER(title) LIKE LOWER(?)"
            parameters.append("%\(title)%")
        }

        if let category = category, !category.isEmpty {
            query += " AND LOWER(tags) LIKE LOWER(?)"
            parameters.append("%\(category)%")
        }

        if let diet = diet, !diet.isEmpty {
            query += " AND LOWER(tags) LIKE LOWER(?)"
            parameters.append("%\(diet)%")
        }

        if let cuisine = cuisine, !cuisine.isEmpty {
            query += " AND LOWER(tags) LIKE LOWER(?)"
            parameters.append("%\(cuisine)%")
        }

        if let sorting = sorting {
            switch sorting {
            case "Название (А-Я)":
                query += " ORDER BY LOWER(title) ASC"
            case "Название (Я-А)":
                query += " ORDER BY LOWER(title) DESC"
            case "По времени (меньше → больше)":
                query += " ORDER BY time ASC"
            case "По времени (больше → меньше)":
                query += " ORDER BY time DESC"
            case "По калориям (меньше → больше)":
                query += " ORDER BY calories ASC"
            case "По калориям (больше → меньше)":
                query += " ORDER BY calories DESC"
            default:
                break
            }
        }

        var recipes: [Recipe] = []

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            for (index, param) in parameters.enumerated() {
                sqlite3_bind_text(statement, Int32(index + 1), param, -1, unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self))
            }

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let image: String
                if let cString = sqlite3_column_text(statement, 2) {
                    image = String(cString: cString)
                } else {
                    image = "default_image"
                }
                let time = Int(sqlite3_column_int(statement, 3))
                let portions = Int(sqlite3_column_int(statement, 4))

                let descriptionPointer = sqlite3_column_text(statement, 5)
                let description = descriptionPointer != nil ? String(cString: descriptionPointer!) : ""
                
                let calories = Int(sqlite3_column_int(statement, 6))
                let protein = Int(sqlite3_column_int(statement, 7))
                let fat = Int(sqlite3_column_int(statement, 8))
                let carbohydrate = Int(sqlite3_column_int(statement, 9))
                
                let ingredientsText = String(cString: sqlite3_column_text(statement, 10))
                let jsonFormattedIngredientsText = ingredientsText.replacingOccurrences(of: "'", with: "\"")
                let ingredientsData = jsonFormattedIngredientsText.data(using: .utf8)!
                let ingredients = try? JSONSerialization.jsonObject(with: ingredientsData, options: []) as? [String: String] ?? [:]
                
                let instructionsText = String(cString: sqlite3_column_text(statement, 11))
                let jsonFormattedInstructionsText = instructionsText.replacingOccurrences(of: "'", with: "\"")
                let instructionsData = jsonFormattedInstructionsText.data(using: .utf8)!
                let instructions = try? JSONSerialization.jsonObject(with: instructionsData, options: []) as? [String] ?? []
                
                let recipe = Recipe(
                    id: id, title: title, image: image, time: time, portions: portions,
                    description: description, calories: calories, protein: protein,
                    fat: fat, carbohydrate: carbohydrate, ingredients: ingredients ?? [:],
                    instructions: instructions ?? []
                )
                recipes.append(recipe)
            }
        } else {
            print("Ошибка запроса: \(String(cString: sqlite3_errmsg(db)))")
        }

        sqlite3_finalize(statement)
        return recipes
    }



}

