//
//  FriendRequest.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/9/24.
//

import Foundation

enum FriendRequestStatus: String, Codable {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
}

struct FriendRequest: Identifiable, Codable {
    var id: String
    var fromUserId: String
    var toUserId: String
    var status: FriendRequestStatus
    var fromUserNick: String
    var fromUserImgUrl: String
    var fromUserPost: Bool
    
    init(id: String, fromUserId: String, toUserId: String, status: FriendRequestStatus, fromUserNick: String, fromUserImgUrl: String = "", fromUserPost: Bool) {
        self.id = id
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.status = status
        self.fromUserNick = fromUserNick
        self.fromUserImgUrl = fromUserImgUrl
        self.fromUserPost = fromUserPost
    }
}

