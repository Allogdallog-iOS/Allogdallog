//
//  FriendsListViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FriendsListViewModel: ObservableObject {
    @Published var user: User
    //@Published var receivedRequests: [FriendRequest] = []
    //@Published var friends: [Friend] = []
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
        //fetchFriendRequests()
        //fetchFriends()
    }

    
    func fetchFriendRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
       
        
        let userRef = db.collection("users").document(currentUserID)
            
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                
                self.user.receivedRequests = (data?["receivedRequests"] as? [[String: Any]] ?? []).compactMap { requestData in
                    FriendRequest(id: requestData["id"] as? String ?? "",
                    fromUserId: requestData["fromUserId"] as? String ?? "",
                    toUserId: requestData["toUserId"] as? String ?? "",
                    status: FriendRequestStatus(rawValue: requestData["status"] as? String ?? "") ?? .pending,
                    fromUserNick: requestData["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: requestData["fromUserImgUrl"] as? String ?? "")
                }

            } else {
                print("User document does not exist")
            }
        }
    }
     
    

    func fetchFriends() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        let userRef = db.collection("users").document(currentUserID)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                
                self.user.friends = (data?["friends"] as? [[String: Any]] ?? []).compactMap { friendData in
                    Friend(id: friendData["id"] as? String ?? "",
                           nickname: friendData["nickname"] as? String ?? "",
                           profileImageUrl: friendData["profileImageUrl"] as? String ?? "")
                }
                
            } else {
                print("User document does not exist")
            }
        }
    }

    
    func acceptFriendRequest(request: FriendRequest) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        let userRef = db.collection("users").document(currentUserID)
        let friendRef = db.collection("users").document(request.fromUserId)
       
        userRef.updateData([
            "friends": FieldValue.arrayUnion([[
                "id": request.fromUserId,
                "nickname": request.fromUserNick,
                "profileImageUrl": request.fromUserImgUrl
            ]]),
            "receivedRequests": FieldValue.arrayRemove([[
                "id": request.id,
                "fromUserId": request.fromUserId,
                "toUserId": request.toUserId,
                "status":  request.status.rawValue,
                "fromUserNick": request.fromUserNick,
                "fromUserImgUrl": request.fromUserImgUrl
            ]])
        ]) { error in
            if let error = error {
                print("Error accepting friend request: \(error)")
            } else {
                let newFriend = Friend(id: request.fromUserId, nickname: request.fromUserNick, profileImageUrl: request.fromUserImgUrl)
                self.user.friends.append(newFriend)
                self.user.receivedRequests.removeAll(where: { $0.id == request.id })
                
                self.createNotificationForFriendAcceptance(friendId: request.fromUserId)
            }
        }
        
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([[
                "id": currentUserID,
                "nickname": self.user.nickname,
                "profileImageUrl": self.user.profileImageUrl ?? "",
            ]]),
            "sentRequests": FieldValue.arrayRemove([[
                "id": request.id,
                "fromUserId": request.fromUserId,
                "toUserId": request.toUserId,
                "status":  request.status.rawValue,
            ]])
        ]) { error in
            if let error = error {
                print("Error updating friend's friend list: \(error)")
            }
        }
    }
    
    private func createNotificationForFriendAcceptance(friendId: String) {
        let notificationMessage = "\(user.nickname)님이 친구 요청을 수락했습니다."
        db.collection("notifications").addDocument(data: [
            "message": notificationMessage,
            "timestamp": Timestamp(),
            "userId": friendId, // 알림을 받을 사용자 ID
            "fromUserId": user.id, // 수락한 사용자 ID
            "notificationType": "friend_acceptance",
            "isRead": false
        ]) { error in
            if let error = error {
                print("Error adding friend acceptance notification: \(error)")
            } else {
                print("Friend acceptance notification added successfully.")
            }
        }
    }
    
    func rejectFriendRequest(request: FriendRequest) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        let userRef = db.collection("users").document(currentUserID)
        let friendRef = db.collection("users").document(request.fromUserId)
        
        userRef.updateData([
            "receivedRequests": FieldValue.arrayRemove([[
                "id": request.id,
                "fromUserId": request.fromUserId,
                "toUserId": request.toUserId,
                "status": request.status.rawValue,
                "fromUserNick": request.fromUserNick,
                "fromUserImgUrl": request.fromUserImgUrl
            ]])
        ]) { error in
            if let error = error {
                print("Error rejecting friend request: \(error)")
            } else {
                self.user.receivedRequests.removeAll(where: { $0.id == request.id })
            }
        }
        
        friendRef.updateData([
            "sentRequests": FieldValue.arrayRemove([[
                "id": request.id,
                "fromUserId": request.fromUserId,
                "toUserId": request.toUserId,
                "status":  request.status.rawValue,
            ]])
        ]) { error in
            if let error = error {
                print("Error updating friend's friend list: \(error)")
            }
        }
    }
    
    func unfriend(friend: Friend) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        let userRef = db.collection("users").document(currentUserID)
        let friendRef = db.collection("users").document(friend.id)
        
        userRef.updateData([
            "friends": FieldValue.arrayRemove([[
                "id": friend.id,
                "nickname": friend.nickname,
                "profileImageUrl": friend.profileImageUrl ?? "",
            ]])
        ]) { error in
            if let error = error {
                print("Error unfriending: \(error)")
            } else {
                self.user.friends.removeAll(where: { $0.id == friend.id })
            }
        }
        
        friendRef.updateData([
            "friends": FieldValue.arrayRemove([[
                "id": currentUserID,
                "nickname": self.user.nickname,
                "profileImageUrl": self.user.profileImageUrl ?? "",
            ]])
        ]) { error in
            if let error = error {
                print("Error removing friend from their list: \(error)")
            }
        }
    }
}
