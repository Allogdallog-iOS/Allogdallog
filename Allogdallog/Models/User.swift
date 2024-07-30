//
//  UserModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import Foundation

struct User: Codable, Identifiable {
    
    var id: String
    var email: String
    var nickname: String = ""
    var profileImageUrl: String?
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
    }
    
    init(id: String, email: String, nickname: String, profileImageUrl: String? = nil) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
}
