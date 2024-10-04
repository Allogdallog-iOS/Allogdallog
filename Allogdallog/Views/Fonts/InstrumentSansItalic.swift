//
//  InstrumentSansItalic.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/4/24.
//

import SwiftUI

enum InstrumentSansItalic {
    case semiBold
    case bold
    
    var name: String {
        switch self {
        case .semiBold:
            return "InstrumentSans-SemiBoldItalic"
        case .bold:
            return "InstrumentSans-BoldItalic"
        }
    }
}
