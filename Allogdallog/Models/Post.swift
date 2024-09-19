//
//  Post.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/23/24.
//

import Foundation

struct Post: Identifiable, Codable {
    
    var id: String = ""
    var todayColor: String = ""
    var todayText: String = ""
    var todayComments: [Comment] = []
    
    init() {
        self.id = ""
        self.todayColor = ""
        self.todayText = ""
        self.todayComments = []
    }
    
    init(id: String = "", todayColor: String = "", todayText: String = "" , todayComments: [Comment] = []) {
        self.id = id
        self.todayColor = todayColor
        self.todayText = todayText
        self.todayComments = todayComments
    }
}
