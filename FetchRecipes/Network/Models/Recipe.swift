//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import Foundation

struct RecipeResponse: Codable {
    let meals: [Recipe]
}

struct Recipe: Codable, Hashable {
    var instructions: String
    var ingredients: [Ingredient] = []
    
    private enum CodingKeys: String, CodingKey {
        case instructions = "strInstructions"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        instructions = try container.decode(String.self, forKey: .instructions)
        
        // grab ingredients and measurements if not empty
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for i in 1...20 {
            if let itemKey = DynamicCodingKeys(stringValue: "strIngredient\(i)"),
               let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)") {
                if let item = try dynamicContainer.decodeIfPresent(String.self, forKey: itemKey), !item.isEmpty,
                   let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey), !measure.isEmpty {
                    let ingredient = Ingredient(
                        order: i,
                        item: item,
                        measure: measure
                    )
                    ingredients.append(ingredient)
                }
            }
        }
    }
    
    // dynamic coding keys to decode multiple items
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }
}
    
struct Ingredient: Codable, Hashable {
    let order: Int
    let item: String
    let measure: String
    var isSelected: Bool = false
}
