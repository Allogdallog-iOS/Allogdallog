//
//  InstrumentSerif.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/4/24.
//

import SwiftUI

enum InstrumentSerif {
    case regular
    case italic
    
    var name: String {
        switch self {
        case .regular:
            return "InstrumentSerif-Regular"
        case .italic:
            return "InstrumentSerif-Italic"
        }
    }
}
