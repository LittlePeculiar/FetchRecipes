//
//  MealViewModel.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/20/24.
//

import Foundation

class MealViewModel: ObservableObject {
    @Published var category: Category
    @Published var meals: [Meal] = []
    @Published var displayMeals: [Meal] = []
    @Published var isLoading: Bool
    @Published var selectedMeal: Meal = Meal(mealID: "", meal: "", mealThumb: "")
    
    var api: APIService
    
    init(api: APIService, category: Category, isLoading: Bool = true) {
        self.api = api
        self.category = category
        self.isLoading = isLoading
        
        Task {
            await fetchMeals()
        }
    }
    
    
    // filter by meals for string entered in search bar
    @MainActor func searchMeals(by searchText: String) async {
        if !searchText.isEmpty {
            displayMeals = meals.filter {
                guard let meal = $0.meal else { return false }
                return meal.lowercased().contains(searchText.lowercased())
            }
        } else {
            displayMeals = meals
        }
    }
    
    // fetch meals from api - currently only searching for desserts
    @MainActor func fetchMeals() async {
        do {
            let results = try await api.fetchData(payloadType: MealResponse.self, from: category.apiEndpoint)
            switch results {
            case .failure(let error):
                print("failed to fetch data: \(error)")
                self.isLoading = false
                
            case .success(let meal):
                print("success: \(String(describing: meal?.meals.count)) records")
                if let meals = meal?.meals {
                    // sort
                    self.meals = meals.sorted(by: {
                        guard let meal0 = $0.meal, let meal1 = $1.meal else { return false }
                        return meal0 < meal1
                    })
                    displayMeals = meals
                    self.isLoading = false
                }
            }
            
        } catch let error {
            print("error fetching meals: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
}

