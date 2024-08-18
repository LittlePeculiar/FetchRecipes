//
//  Meal.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import Foundation

struct MealResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Hashable {
    let mealID: String
    let meal: String
    let mealThumb: String
    
    private enum CodingKeys: String, CodingKey {
        case mealID = "idMeal", meal = "strMeal", mealThumb = "strMealThumb"
    }
}
