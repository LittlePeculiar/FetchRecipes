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
        NavigationView {
            ZStack {
                Color.blue.opacity(0.3).edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        ForEach(viewModel.categories, id: \.self) { category in
                            HStack {
                                HStack {
                                    NavigationLink {
                                        MealView(
                                            viewModel: MealViewModel(
                                                api: API(),
                                                category: category
                                            )
                                        )
                                    } label: {
                                        HStack {
                                            Text(category.title)
                                                .foregroundColor(.black)
                                                .font(.title2)
                                                .padding(.vertical, 5)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .contentShape(Rectangle())
                                .cornerRadius(5.0)
                            }
                            .padding([.top, .bottom], 2)
                            .padding([.trailing, .leading], 10)
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("Recipes")
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
