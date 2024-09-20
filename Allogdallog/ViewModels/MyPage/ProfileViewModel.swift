//
//  ProfileViewModel.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    
    @Published var user: User
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
    }
    
    func profileManage() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
       
        db.collection("users")

    }
}
