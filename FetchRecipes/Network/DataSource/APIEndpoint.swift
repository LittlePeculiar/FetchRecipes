//
//  APIEndpoint.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/17/24.
//

import Foundation

// MARK: defines all endpoints used in app

enum APIEndpoint: Hashable {
    case desserts
    case detailsBy(mealId: String)
}

extension APIEndpoint {
    private var baseUrl: String {
        "https://themealdb.com/api/json/v1/1/"
    }
    
    var path: String {
        switch self {
        case .desserts:
            return "\(baseUrl)filter.php?c=Dessert"
        case let .detailsBy(mealId):
            return "\(baseUrl)lookup.php?i=\(mealId)"
        }
    }
}
