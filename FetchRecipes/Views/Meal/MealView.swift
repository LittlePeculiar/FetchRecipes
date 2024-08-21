//
//  MealView.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/20/24.
//

import SwiftUI

import SwiftUI

struct MealView: View {
    @StateObject var viewModel: MealViewModel
    @State private var showDetail: Bool = false
    @State private var searchText = ""
    
    var body: some View {
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
                        ForEach(viewModel.displayMeals, id: \.self) { meal in
                            Button {
                                viewModel.selectedMeal = meal
                                showDetail = true
                            } label: {
                                MealCard(
                                    viewModel: MealCardViewModel(
                                        mealName: meal.meal ?? "",
                                        imageURL: meal.mealThumb ?? ""
                                    )
                                )
                            }
                        }
                    }
                    .sheet(isPresented: $showDetail) {
                        MealDetailView(
                            viewModel: MealDetailViewModel(
                                api: viewModel.api,
                                meal: viewModel.selectedMeal
                            )
                        )
                    }
                }
                
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { searchText in
            Task {
                await viewModel.searchMeals(by: searchText)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(viewModel.category.title).font(.title)
                        }
                    }
                }
                
        
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView(
            viewModel: MealViewModel(api: MockAPI(), category: .dessert)
        )
    }
}

