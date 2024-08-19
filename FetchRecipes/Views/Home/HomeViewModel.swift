//
//  HomeViewModel.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading: Bool
    @Published var selectedMeal: Meal = Meal(mealID: "", meal: "", mealThumb: "")
    
    init(isLoading: Bool = true) {
        self.isLoading = isLoading
        
        Task {
            await fetchMeals()
        }
    }
    
    @MainActor private func fetchMeals() async {
        do {
            let results = try await API.shared.fetchData(payloadType: MealResponse.self, from: .desserts)
            switch results {
            case .failure(let error):
                print("failed to fetch data: \(error)")
                self.isLoading = false
                
            case .success(let meal):
                print("success: \(String(describing: meal?.meals.count)) records")
                if let meals = meal?.meals {
                    // sort
                    self.meals = meals.sorted(by: {
                        $0.meal < $1.meal
                    })
                    self.isLoading = false
                }
            }
            
        } catch let error {
            print("error fetching meals: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
}
