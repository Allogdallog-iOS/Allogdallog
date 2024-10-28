//
//  AppNotification.swift
//  Allogdallog
//
//  Created by 김유진 on 10/25/24.
//

import Foundation

struct AppNotification: Identifiable {
    var id: String { message + timestamp.description } // 고유 ID 생성
    let message: String
    let timestamp: Date
    let fromUserId: String
    let notificationType: String
}
