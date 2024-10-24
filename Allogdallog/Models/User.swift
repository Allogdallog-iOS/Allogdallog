//
//  UserModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import Foundation
import Combine
import SwiftUI

struct User: Codable, Identifiable {
    
    var id: String
    var email: String
    var nickname: String = ""
    var profileImageUrl: String?
    var friends: [Friend]
    var sentRequests: [FriendRequest]
    var receivedRequests: [FriendRequest]
    var postUploaded: Bool
    var selectedUser: String
    var myColors: [String]
    var myEmojis: [String]
    
    init(id: String, email: String, nickname: String = "", profileImageUrl: String? = nil, friends: [Friend] = [], sentRequests: [FriendRequest] = [], receivedRequests: [FriendRequest] = [], postUploaded: Bool = false, selectedUser: String = "", myColors: [String] = [], myEmojis: [String] = []) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.friends = friends
        self.sentRequests = sentRequests
        self.receivedRequests = receivedRequests
        self.postUploaded = postUploaded
        self.selectedUser = selectedUser
        self.myColors = myColors
        self.myEmojis = myEmojis
    }
}
