//
//  SignInViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/26/24.
//

import Foundation
import FirebaseAuth

class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var errorMessage: String? = nil
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            guard let authResult = authResult else {return}
            self?.user = User(id: authResult.user.uid, email: authResult.user.email ?? "")
            self?.isLoggedIn = true
            
        }
    }
}
