//
//  EmojiTextField.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/25/24.
//

import SwiftUI
import UIKit

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.delegate = context.coordinator
        textField.placeholder = "🆕"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 32)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(_parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(_parent: EmojiTextField) {
            self.parent = _parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let lastCharacter = textField.text?.last, lastCharacter.checkEmoji {
                parent.text = String(lastCharacter)
                textField.text = parent.text
            } else {
                textField.text = ""
                parent.text = ""
            }
        }
    }
}

extension Character {
    var checkEmoji: Bool {
        return unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
}
