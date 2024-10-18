//
//  Friend.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/1/24.
//

import Foundation

struct Friend: Identifiable, Codable {
    
    var id: String
    var nickname: String = ""
    var profileImageUrl: String?
    var postUploaded: Bool = false
    
    init(id: String, nickname: String, profileImageUrl: String, postUploaded: Bool = false) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.postUploaded = postUploaded
    }
    // Firestore에서 읽은 데이터를 바탕으로 초기화
       init?(dictionary: [String: Any]) {
           guard let id = dictionary["id"] as? String,
                 let nickname = dictionary["nickname"] as? String else {
               return nil
           }
           self.id = id
           self.nickname = nickname
           self.profileImageUrl = dictionary["profileImageUrl"] as? String
           self.postUploaded = dictionary["postUploaded"] as? Bool ?? false
       }
       
       // Firestore에 저장할 딕셔너리 형태로 변환
       func toDictionary() -> [String: Any] {
           return [
               "id": id,
               "nickname": nickname,
               "profileImageUrl": profileImageUrl ?? "",
               "postUploaded": postUploaded
           ]
       }
}
