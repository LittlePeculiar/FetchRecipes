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
            Rectangle()
                .foregroundColor(.blue.opacity(0.3))
                .edgesIgnoringSafeArea(.all)
            
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
                                api: viewModel.api,
                                mealName: viewModel.meal.meal ?? "",
                                imageURL: viewModel.meal.mealThumb ?? ""
                            )
                        )
                        
                        CustomSegmentedControl(
                            selectedIndex: $selectedIndex,
                            options: [detailOption.instructions.title, detailOption.ingredients.title]
                        )
                        .padding(.horizontal, 10)
                        
                        if selectedIndex == 0 {
                            instructionView
                        } else {
                            ingredientsView
                        }
                        
                        Spacer()
                    }
                }
                
            }
        }
    }
}

extension MealDetailView {
    var instructionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(viewModel.instructions.enumerated()), id: \.element) { (index, item) in
                if !item.isEmpty {
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index+1).")
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("\(item).")
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.ingredients.indices, id: \.self) { index in
                let ingredient = self.$viewModel.ingredients[index]
                IngredientCard(ingredient: ingredient)
            }
        }
        
    }
            
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(
            viewModel: MealDetailViewModel(
                api: MockAPI(),
                meal: Meal(
                    mealID: "52893",
                    meal: "Apple & Blackberry Crumble",
                    mealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
                )
            )
        )
    }
}
