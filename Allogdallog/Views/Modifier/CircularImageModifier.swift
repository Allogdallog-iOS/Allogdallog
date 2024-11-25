//
//  CircularImageModifier.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/9/24.
//

import SwiftUI

struct CircularImageModifier: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

extension Image {
    func circularImage(size: CGFloat) -> some View {
        self
            .resizable()
            .modifier(CircularImageModifier(size: size))
    }
}
