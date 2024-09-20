//
//  MyPageViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 9/20/24.
//

import Foundation
import FirebaseAuth

class MyPageViewModel: ObservableObject {
    
    @Published var isSignedOut: Bool = false
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedOut = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
