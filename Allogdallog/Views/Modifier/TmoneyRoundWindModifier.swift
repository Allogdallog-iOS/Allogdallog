//
//  TmoneyRoundWindModifier.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/27/24.
//
import SwiftUI

struct TmoneyRoundWindModifier: ViewModifier {
    var fontType: TmoneyRoundWind
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom(fontType.name, size: size))
    }
}

extension View {
    func tmoneyRoundWind(type: TmoneyRoundWind = .regular, size: CGFloat = 20) -> some View {
        self.modifier(TmoneyRoundWindModifier(fontType: type, size: size))
    }
}
