//
//  HomeView.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State var showDetail: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.blue).opacity(0.3)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView() {
                        Text("Loading...")
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.meals, id: \.self) { meal in
                                Button {
                                    viewModel.selectedMeal = meal
                                    showDetail = true
                                } label: {
                                    MealCard(
                                        viewModel: MealCardViewModel(
                                            mealName: meal.meal,
                                            imageURL: meal.mealThumb
                                        )
                                    )
                                }
                            }
                        }
                        .sheet(isPresented: $showDetail) {
                            MealDetailView(
                                viewModel: MealDetailViewModel(
                                    meal: viewModel.selectedMeal
                                )
                            )
                        }
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Dessert").font(.title)
                            }
                        }
                    }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            viewModel: HomeViewModel()
        )
    }
}
