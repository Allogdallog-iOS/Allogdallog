//
//  Post.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/23/24.
//

import Foundation

struct Post: Identifiable, Codable {
    
    var id: String
    var todayImageUrl: String
    var todayColor: String
    var todayComment: String
    
    init(id: String, todayImageUrl: String, todayColor: String, todayComment: String) {
        self.id = id
        self.todayImageUrl = todayImageUrl
        self.todayColor = todayColor
        self.todayComment = todayComment
    }
}
