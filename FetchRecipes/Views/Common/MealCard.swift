//
//  MealCard.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

struct MealCard: View {
    @StateObject var viewModel: MealCardViewModel
    @State var mealImage: UIImage? = nil
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                if let image = mealImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        
                    Text(viewModel.mealName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                }
            }
            .padding(10)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
        }
        .task {
            mealImage = await viewModel.fetchImage()
        }
        .padding()
    }
}

struct MealCard_Previews: PreviewProvider {
    static var previews: some View {
        MealCard(
            viewModel: MealCardViewModel(
                mealName: "Treacle Tart",
                imageURL: "https://www.themealdb.com/images/media/meals/wprvrw1511641295.jpg"
            )
        )
    }
}
