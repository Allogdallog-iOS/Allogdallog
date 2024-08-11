//
//  UserModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import Foundation
import Combine

struct User: Codable, Identifiable {
    
    var id: String
    var email: String
    var nickname: String = ""
    var profileImageUrl: String?
    var friends: [Friend]
    var sentRequests: [FriendRequest]
    var receivedRequests: [FriendRequest]
    
    init(id: String, email: String, friends: [Friend] = [], sentRequests: [FriendRequest] = [], receivedRequests: [FriendRequest] = []) {
        self.id = id
        self.email = email
        self.friends = friends
        self.sentRequests = sentRequests
        self.receivedRequests = receivedRequests
    }
    
    init(id: String, email: String, nickname: String, profileImageUrl: String? = nil, friends: [Friend] = [], sentRequests: [FriendRequest] = [], receivedRequests: [FriendRequest] = []) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.friends = friends
        self.sentRequests = sentRequests
        self.receivedRequests = receivedRequests
    }
}
