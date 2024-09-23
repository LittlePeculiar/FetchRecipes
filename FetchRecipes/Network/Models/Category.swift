//
//  Category.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 9/23/24.
//

import Foundation

enum Category: CaseIterable {
    // todo: additional categories here
    case dessert
    
    var apiEndpoint: APIEndpoint {
        switch self {
        case .dessert:
            return APIEndpoint.desserts
        }
    }
    
    var title: String {
        switch self {
        case .dessert:
            return "Dessert"
        }
    }
}
