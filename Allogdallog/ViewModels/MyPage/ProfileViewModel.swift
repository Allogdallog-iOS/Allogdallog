//
//  ProfileViewModel.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    
    @Published var user: User
    @Published var profileImage: UIImage? = nil
    @Published var isImagePickerPresented: Bool = false
    @Published var nickname: String = ""
    @Published var errorMessage: String? = nil
    
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
