//
//  Comment.swift
//  Allogdallog
//
//  Created by 믕진희 on 9/12/24.
//

import Foundation

struct Comment: Identifiable, Codable {
    
    var id: String
    var postId: String
    var fromUserId: String
    var fromUserNick: String
    var fromUserImgUrl: String
    var comment: String
    
    init(id: String, postId: String, fromUserId: String, fromUserNick: String, fromUserImgUrl: String, comment: String = "") {
        self.id = id
        self.postId = postId
        self.fromUserId = fromUserId
        self.fromUserNick = fromUserNick
        self.fromUserImgUrl = fromUserImgUrl
        self.comment = comment
    }
}
