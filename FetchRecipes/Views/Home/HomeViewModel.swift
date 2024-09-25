//
//  HomeViewModel.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    var api: APIService
    
    init(api: APIService) {
        self.api = api
        
        categories = Category.allCases
    }
}
