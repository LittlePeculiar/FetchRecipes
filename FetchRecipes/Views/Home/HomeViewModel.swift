//
//  HomeViewModel.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool
    
    var api: APIService
    
    init(api: APIService, isLoading: Bool = true) {
        self.api = api
        self.isLoading = isLoading
        
        categories = Category.allCases
        
    }
}
