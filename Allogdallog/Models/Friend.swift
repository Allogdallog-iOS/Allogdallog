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
    var postUploaded: Bool = false
    var profileImageUrl: String?
    
    init(id: String, nickname: String, postUploaded: Bool = false, profileImageUrl: String) {
        self.id = id
        self.nickname = nickname
        self.postUploaded = postUploaded
        self.profileImageUrl = profileImageUrl
    }
    
}
