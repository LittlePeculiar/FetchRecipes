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
    
    init(meal: Meal, isLoading: Bool = true) {
        self.meal = meal
        self.isLoading = isLoading
        
        Task {
            await fetchDetail(mealID: meal.mealID)
        }
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
                    self.isLoading = false
                    
                    print(self.recipe?.instructions ?? "")
                    print(self.recipe?.ingredients ?? "")
                }
            }
            
        } catch let error {
            print("error fetching meals: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
}
