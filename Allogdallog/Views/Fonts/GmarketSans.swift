//
//  GmarketSans.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/27/24.
//

import SwiftUI

enum GmarketSans {
    case bold
    case medium
    case light
    
    var name: String {
        switch self {
        case .bold:
            return "GmarketSansTTFBold"
        case .medium:
            return "GmarketSansTTFMedium"
        case .light:
            return "GmarketSansTTFLight"
        }
    }
}
