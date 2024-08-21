//
//  MealDetailViewModelTest.swift
//  FetchRecipesTests
//
//  Created by Gina Mullins on 8/20/24.
//

import XCTest
@testable import FetchRecipes

final class MealDetailViewModelTest: XCTestCase {
    var viewModel: MealDetailViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func test_MealDetailViewModel_fetchDetail() {
        
        let meal = Meal(
            mealID: "52893",
            meal: "Apple & Blackberry Crumble",
            mealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
        )
        // test MealDetailViewModel init
        viewModel = MealDetailViewModel(api: MockAPI(), meal: meal)
        XCTAssertNotNil(viewModel)
        
        let expectation = self.expectation(description: "Test Fetching Meal Detail")
        
        let api = MockAPI()
        
        Task {
            do {
                let mealID = meal.mealID ?? ""
                let results = try await api.fetchData(payloadType: RecipeResponse.self, from: .detailsBy(mealId: mealID))
                switch results {
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    
                    case .success(let detail):
                        print("success: \(String(describing: detail?.meals.count)) records")
                        if let meals = detail?.meals {
                            XCTAssertEqual(meals.count, 1)
                            
                            if let recipeDetails = meals.first {
                                XCTAssertEqual(recipeDetails.mealID, "52893")
                                XCTAssertTrue(recipeDetails.ingredients.count == 9)
                                
                                // parse instructions
                                if let string = recipeDetails.instructions {
                                    let lines = string.components(separatedBy: ".")
                                    let instr = lines.compactMap({
                                        return $0.trimmingCharacters(in: .whitespacesAndNewlines)
                                    })
                                    XCTAssertTrue(!instr.isEmpty)
                                }
                            }
                            expectation.fulfill()
                        }
                }
                
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
    }
}
