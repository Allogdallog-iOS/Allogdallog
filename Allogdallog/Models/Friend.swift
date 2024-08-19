//
//  Friend.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/1/24.
//

import Foundation

struct Friend: Identifiable, Codable {
    
    var id: String
    var nickname: String = ""
    var profileImageUrl: String?
    var postUploaded: Bool = false
    
    init(id: String, nickname: String, profileImageUrl: String, postUploaded: Bool = false) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.postUploaded = postUploaded
    }
    
}
