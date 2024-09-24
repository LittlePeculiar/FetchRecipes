//
//  CustomSegmentedControl.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/18/24.
//

/*
 *** Custom Segment Control ***
 input:
    selectedIndex: The index of the segment option - Binding variable
    options: An array of options to be displayed
    color: The color of the text and background - defaults to white
 */

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    var options: [String]
    var color = Color.white

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

struct CustomSegmentedControl_Previews: PreviewProvider {
    @State static var index = 0
    
    static var previews: some View {
        CustomSegmentedControl(
            selectedIndex: $index,
            options: ["one", "two"],
            color: Color.blue
        )
    }
}
