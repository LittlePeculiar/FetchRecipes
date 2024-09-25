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
    @Published var isLoading: Bool = true
    
    @Published var recipe: Recipe?
    @Published var ingredients: [Ingredient] = []
    
    var api: APIService
    
    init(api: APIService, meal: Meal) {
        self.api = api
        self.meal = meal
        
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
    
    // fetch details from api by mealID
    @MainActor private func fetchDetail(mealID: String) async {
        do {
            let results = try await api.fetchData(payloadType: RecipeResponse.self, from: .detailsBy(mealId: mealID))
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
                    
                    print("**********")
                    print(recipe)
                    print(ingredients)
                    print("**********")
                }
            }
            
        } catch let error {
            print("error fetching meals: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
}
