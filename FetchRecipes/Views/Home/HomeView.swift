//
//  HomeView.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color(.blue).opacity(0.3)
                .ignoresSafeArea()
            
            NavigationView {
                List(viewModel.categories, id: \.self) { category in
                    NavigationLink {
                        MealView(
                            viewModel: MealViewModel(
                                api: API(),
                                category: category
                            )
                        )
                    } label: {
                        Text(category.title)
                            .font(.title2)
                    }
                }
                .navigationTitle("Recipes")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            viewModel: HomeViewModel(api: MockAPI())
        )
    }
}
