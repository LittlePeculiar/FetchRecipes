//
//  MealDetailViewModel.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

enum detailOption {
    case ingredients, instructions
    
    var title: String {
        switch self {
        case .ingredients:
            return "Ingredients"
        case .instructions:
            return "Instructions"
        }
    }
}


class MealDetailViewModel: ObservableObject {
    @Published var meal: Meal
    @Published var isLoading: Bool
    
    @Published var recipe: Recipe?
    @Published var ingredients: [Ingredient] = []
    
    init(meal: Meal, isLoading: Bool = true) {
        self.meal = meal
        self.isLoading = isLoading
        
        Task {
            await fetchDetail(mealID: meal.mealID ?? "")
        }
    }
    
    var instructions: [String] {
        guard let string = self.recipe?.instructions else { return [] }
        let lines = string.components(separatedBy: ".")
        let instr = lines.compactMap({
            return $0.trimmingCharacters(in: .whitespacesAndNewlines)
        })
        
        return instr
    }
    
    @MainActor private func fetchDetail(mealID: String) async {
        do {
            let results = try await API.shared.fetchData(payloadType: RecipeResponse.self, from: .detailsBy(mealId: mealID))
            switch results {
            case .failure(let error):
                print("failed to fetch detail data: \(error)")
                self.isLoading = false
                
            case .success(let detail):
                print("success: \(String(describing: detail?.meals.count)) records")
                if let recipe = detail?.meals {
                    self.recipe = recipe.first
                    self.ingredients = self.recipe?.ingredients ?? []
                    self.isLoading = false
                }
            }
            
        } catch let error {
            print("error fetching meals: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
}
