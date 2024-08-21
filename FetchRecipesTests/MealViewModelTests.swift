//
//  MealViewModelTests.swift
//  FetchRecipesTests
//
//  Created by Gina Mullins on 8/20/24.
//

import XCTest
@testable import FetchRecipes

final class MealViewModelTests: XCTestCase {
    var viewModel: MealViewModel?
    let meals: [Meal] = [
        Meal(
            mealID: "52893",
            meal: "Apple & Blackberry Crumble",
            mealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
        )
    ]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func test_MealViewModel_FetchMeals() {
        let expectation = self.expectation(description: "Test Fetching Meals")
        
        // test HomeViewModel init
        viewModel = MealViewModel(api: MockAPI(), category: .dessert)
        XCTAssertNotNil(viewModel)
        
        let api = MockAPI()
        
        Task {
            do {
                let results = try await api.fetchData(payloadType: MealResponse.self, from: Category.dessert.apiEndpoint)
                switch results {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    
                case .success(let meal):
                    print("success: \(String(describing: meal?.meals.count)) records")
                    if let meals = meal?.meals {
                        XCTAssertEqual(meals.count, 4)
                        
                        if let meal = meals.first {
                            print("meals: \(meal)")
                            XCTAssertEqual(meal.mealID, "52893")
                            XCTAssertEqual(meal.meal, "Apple & Blackberry Crumble")
                            if let thumb = meal.mealThumb {
                                XCTAssertFalse(thumb.isEmpty)
                            } else {
                                XCTAssertNil(meal.mealThumb)
                            }
                        }
                        expectation.fulfill()
                        
                    } else {
                        XCTAssertNil(meal)
                    }
                }
                
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    func test_MealViewModel_SearchMeals() {
        var displayMeals: [Meal] = []
        
        let searchText = "apple"
        
        displayMeals = meals.filter {
            guard let meal = $0.meal else { return false }
            return meal.lowercased().contains(searchText.lowercased())
        }
        XCTAssertFalse(displayMeals.isEmpty)
    }
    
    func test_MealViewModel_SearchMealsNotFound() {
        var displayMeals: [Meal] = []
        
        let searchText = "test"
        
        displayMeals = meals.filter {
            guard let meal = $0.meal else { return false }
            return meal.lowercased().contains(searchText.lowercased())
        }
        XCTAssertTrue(displayMeals.isEmpty)
    }

}

