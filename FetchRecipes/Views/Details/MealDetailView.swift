//
//  MealDetailView.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject var viewModel: MealDetailViewModel
    @State private var selectedIndex = 0
    
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
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .center) {
                            Spacer()
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 40, height: 5)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.top, 20)
                        
                        MealCard(
                            viewModel: MealCardViewModel(
                                mealName: viewModel.meal.meal,
                                imageURL: viewModel.meal.mealThumb
                            )
                        )
                        
                        CustomSegmentedControl(
                            selectedIndex: $selectedIndex,
                            options: [detailOption.instructions.title, detailOption.ingredients.title]
                        )
                        .padding(.horizontal, 10)
                        
                        
                        
                        Spacer()
                    }
                }
                
            }
        }
    }
}

extension MealDetailView {
    
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(
            viewModel: MealDetailViewModel(
                meal: Meal(
                    mealID: "52893",
                    meal: "Apple & Blackberry Crumble",
                    mealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
                ),
                isLoading: false
            )
        )
    }
}
