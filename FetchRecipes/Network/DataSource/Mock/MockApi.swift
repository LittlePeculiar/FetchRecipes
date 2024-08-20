//
//  MockApi.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/20/24.
//

import SwiftUI

class MockAPI: APIService {
    
    private let decoder = JSONDecoder()
    
    func fetchData<T: Decodable>(
        payloadType: T.Type,
        from endpoint: APIEndpoint,
        body: Encodable? = nil,
        method: Method = .GET
    ) async throws -> (Result<T?, APIError>) {
        // mock data and response
        var json: String = ""
        
        if payloadType == MealResponse.self {
            json = mockMealsJson
        } else if payloadType == RecipeResponse.self {
            json = mockDetailsJson
        }
        
        if json.isEmpty {
            return .failure(.noData)
        }
        
        let data = Data(json.utf8)
        guard let decodedResponse = try? decoder.decode(payloadType, from: data) else {
            return .failure(.decodingError)
        }
        return .success(decodedResponse)
    }
}

let mockMealsJson = """
{
    "meals":[
    {
        "strMeal":"Apple & Blackberry Crumble",
        "strMealThumb":"https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
        "idMeal":"52893"
    }
}
"""

let mockDetailsJson = """
{
    "meals":[{
        "idMeal":"52893",
        "strInstructions":"Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.",
        "strIngredient1":"Plain Flour",
        "strIngredient2":"Caster Sugar",
        "strIngredient3":"Butter",
        "strIngredient4":"Braeburn Apples",
        "strIngredient5":"Butter",
        "strIngredient6":"Demerara Sugar",
        "strIngredient7":"Blackberrys",
        "strIngredient8":"Cinnamon",
        "strIngredient9":"Ice Cream",
        "strIngredient10":"",
        "strIngredient11":"",
        "strIngredient12":"",
        "strIngredient13":"",
        "strIngredient14":"",
        "strIngredient15":"",
        "strIngredient16":"",
        "strIngredient17":"",
        "strIngredient18":"",
        "strIngredient19":"",
        "strIngredient20":"",
        "strMeasure1":"120g",
        "strMeasure2":"60g",
        "strMeasure3":"60g",
        "strMeasure4":"300g",
        "strMeasure5":"30g",
        "strMeasure6":"30g",
        "strMeasure7":"120g",
        "strMeasure8":"teaspoon",
        "strMeasure9":"to serve",
        "strMeasure10":"",
        "strMeasure11":"",
        "strMeasure12":"",
        "strMeasure13":"",
        "strMeasure14":"",
        "strMeasure15":"",
        "strMeasure16":"",
        "strMeasure17":"",
        "strMeasure18":"",
        "strMeasure19":"",
        "strMeasure20":""
    }]
}

"""
