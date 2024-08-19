//
//  CustomSegmentedControl.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    var options: [String]
    let color = Color.white

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))

                    Rectangle()
                        .fill(color)
                        .cornerRadius(20)
                        .padding(2)
                        .opacity(selectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    selectedIndex = index
                                }
                            }
                }
                .overlay(
                    Text(options[index])
                        .foregroundColor(.black)
                )
            }
        }
        .frame(height: 50)
        .cornerRadius(20)
    }
}
