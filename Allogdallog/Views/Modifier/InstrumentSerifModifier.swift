//
//  InstrumentSerifModifier.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/4/24.
//

import SwiftUI

struct InstrumentSerifModifier: ViewModifier {
    var fontType: InstrumentSerif
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom(fontType.name, size: size))
    }
}

extension View {
    func instrumentSerif(type: InstrumentSerif = .regular, size: CGFloat = 20) -> some View {
        self.modifier(InstrumentSerifModifier(fontType: type, size: size))
    }
}
