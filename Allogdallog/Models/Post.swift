//
//  Post.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/23/24.
//

import Foundation
import FirebaseCore
import UIKit

struct Post: Identifiable, Codable {
    
    var id: String = ""
    var userId: String
    var todayDate: Date
    var todayImgUrl: String = ""
    var todayColor: String = ""
    var todayText: String = ""
    var todayShape: String = ""
    var todayComments: [Comment] = []
    
    init(userId: String) {
        self.id = ""
        self.userId = userId
        self.todayDate = Date()
        self.todayImgUrl = ""
        self.todayColor = ""
        self.todayText = ""
        self.todayComments = []
    }
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.userId = data["userId"] as? String ?? ""
        self.todayDate = (data["todayDate"] as? Timestamp)?.dateValue() ?? Date()
        self.todayImgUrl = data["todayImgUrl"] as? String ?? ""
        self.todayColor = data["todayColor"] as? String ?? ""
        self.todayText = data["todayText"] as? String ?? ""
        self.todayShape = data["todayShape"] as? String ?? ""
        self.todayComments = (data["todayComments"] as? [[String: Any]] ?? []).compactMap { comment in
            Comment(id: comment["id"] as? String ?? "",
                    postId: comment["postId"] as? String ?? "",
                    fromUserId: comment["fromUserId"] as? String ?? "",
                    fromUserNick: comment["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: comment["fromUserImgUrl"] as? String ?? "",
                    comment: comment["comment"] as? String ?? "")
        }
    }
    
    init(id: String = "", userId: String = "", todayDate: Date = Date(), todayImgUrl: String = "", todayColor: String = "", todayText: String = "" , todayShape: String = "",todayComments: [Comment] = []) {
        self.id = id
        self.userId = userId
        self.todayDate = todayDate
        self.todayImgUrl = todayImgUrl
        self.todayColor = todayColor
        self.todayText = todayText
        self.todayShape = todayShape
        self.todayComments = todayComments
    }
}
