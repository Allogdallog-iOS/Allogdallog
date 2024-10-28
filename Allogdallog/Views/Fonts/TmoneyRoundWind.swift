//
//  TmoneyRoundWind.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/27/24.
//

import SwiftUI

enum TmoneyRoundWind {
    case extraBold
    case regular
    
    var name: String {
        switch self {
        case .extraBold:
            return "TmoneyRoundWindExtraBold"
        case .regular:
            return "TmoneyRoundWindRegular"
        }
    }
}
