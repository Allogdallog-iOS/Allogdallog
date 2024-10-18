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
    
    init(id: String, fromUserId: String, toUserId: String, status: FriendRequestStatus, fromUserNick: String, fromUserImgUrl: String = "") {
        self.id = id
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.status = status
        self.fromUserNick = fromUserNick
        self.fromUserImgUrl = fromUserImgUrl
    }
    // Firestore에서 읽은 데이터를 바탕으로 초기화
        init?(dictionary: [String: Any]) {
            guard let id = dictionary["id"] as? String,
                  let fromUserId = dictionary["fromUserId"] as? String,
                  let toUserId = dictionary["toUserId"] as? String,
                  let statusString = dictionary["status"] as? String,
                  let status = FriendRequestStatus(rawValue: statusString),
                  let fromUserNick = dictionary["fromUserNick"] as? String else {
                return nil
            }
            self.id = id
            self.fromUserId = fromUserId
            self.toUserId = toUserId
            self.status = status
            self.fromUserNick = fromUserNick
            self.fromUserImgUrl = dictionary["fromUserImgUrl"] as? String ?? ""
        }
        
        // Firestore에 저장할 딕셔너리 형태로 변환
        func toDictionary() -> [String: Any] {
            return [
                "id": id,
                "fromUserId": fromUserId,
                "toUserId": toUserId,
                "status": status.rawValue,
                "fromUserNick": fromUserNick,
                "fromUserImgUrl": fromUserImgUrl
            ]
        }
}

