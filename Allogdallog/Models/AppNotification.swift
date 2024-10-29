//
//  AppNotification.swift
//  Allogdallog
//
//  Created by 김유진 on 10/25/24.
//

import Foundation

struct AppNotification: Identifiable {
    //var id: String { message + timestamp.description }
    var id: String
    var userId: String
    let message: String
    let timestamp: Date
    let fromUserId: String
    let notificationType: String
    var isRead: Bool
    
}
