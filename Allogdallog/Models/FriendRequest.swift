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
}
