//
//  GmarketSansModifier.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/27/24.
//

import SwiftUI

struct GmarketSansModifier: ViewModifier {
    var fontType: GmarketSans
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom(fontType.name, size: size))
    }
}

extension View {
    func gmarketSans(type: GmarketSans = .medium, size: CGFloat = 20) -> some View {
        self.modifier(GmarketSansModifier(fontType: type, size: size))
    }
}
