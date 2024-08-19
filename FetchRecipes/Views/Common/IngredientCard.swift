//
//  IngredientCard.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

struct IngredientCard: View {
    @State var ingredient: Ingredient
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center, spacing: 30) {
                Image(systemName: ingredient.isSelected ? "circle.fill" : "circle")
                
                HStack(alignment: .center, spacing: 10) {
                    Text(ingredient.measure)
                        .foregroundColor(.black)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(ingredient.item)
                        .foregroundColor(.black)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
        }
        .padding()
        .onTapGesture {
            ingredient.isSelected = !ingredient.isSelected
        }
    }
}

struct IngredientCard_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCard(
            ingredient: Ingredient(
                order: 1,
                item: "Milk",
                measure: "200ml",
                isSelected: false
            )
        )
    }
}
