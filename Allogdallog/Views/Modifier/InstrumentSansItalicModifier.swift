//
//  InstrumentSansItalicModifier.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/4/24.
//

import SwiftUI

struct InstrumentSansItalicModifier: ViewModifier {
    var fontType: InstrumentSansItalic
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom(fontType.name, size: size))
    }
}

extension View {
    func instrumentSansItalic(type: InstrumentSansItalic = .semiBold, size: CGFloat = 20) -> some View {
        self.modifier(InstrumentSansItalicModifier(fontType: type, size: size))
    }
}
