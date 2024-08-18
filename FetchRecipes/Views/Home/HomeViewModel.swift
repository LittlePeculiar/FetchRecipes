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
                print("failed to fetch reddit posts: \(error)")
                
            case .success(let meal):
                print("success: \(String(describing: meal?.meals.count)) records")
                if let meals = meal?.meals {
                    self.meals = meals.sorted(by: {
                        $0.meal < $1.meal
                    })
                    print(self.meals)
                }
            }
            
        } catch let error {
            print("error fetching meals: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
}
