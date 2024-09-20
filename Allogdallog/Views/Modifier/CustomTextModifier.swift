//
//  CustomTextModifier.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/8/24.
//

import SwiftUI

struct CustomTextModifier: ViewModifier {
    
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .overlay(RoundedRectangle(cornerRadius: 10.0)
                .stroke(Color.myLightGray)
            )
    }
}

extension View {
    func customTextFieldStyle(height: CGFloat) -> some View {
        self.modifier(CustomTextModifier(height: height))
    }
}
