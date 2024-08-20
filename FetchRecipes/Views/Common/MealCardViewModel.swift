//
//  MealCardViewModel.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

class MealCardViewModel: ObservableObject {
    @Published var mealName: String
    @Published var imageURL: String
    
    init(mealName: String, imageURL: String) {
        self.mealName = mealName
        self.imageURL = imageURL
    }
    
    // fetch image, either from local or api
    @MainActor func fetchImage() async -> UIImage? {
        do {
            let image = try await ImageDownloader.shared.fetchImage(urlPath: self.imageURL)
            return image
        } catch let error {
            print("error fetching image: \(imageURL) :: \(error.localizedDescription)")
        }
        return nil
    }
}

