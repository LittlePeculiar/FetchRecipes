//
//  PrimaryButton.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/27/24.
//

import SwiftUI

struct PrimaryButton: View {
    // MARK: Lifecycle

    init(_ text: String,
         textColor: Color = .white,
         font: Font = .callout,
         bgColor: Color = .red,
         action: @escaping () -> Void
    ) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.bgColor = bgColor
        self.action = action
    }

    // MARK: Internal

    let text: String
    let textColor: Color
    let font: Font
    let bgColor: Color
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                Text(text)
                .font(font)
                .foregroundColor(textColor)
                .padding(12.0)
                .frame(width: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(bgColor)
                )
            }
        )
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton("press me", action: {})
    }
}
