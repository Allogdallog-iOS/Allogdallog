//
//  FriendSearchViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FriendSearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var searchResults: [User] = []
    @Published var user: User
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
        //fetchFriendRequests()
    }
    
    func searchFriends() {
        db.collection("users")
            .whereField("nickname", isEqualTo: searchText)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching friends: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self.searchResults = documents.compactMap { doc -> User? in
                    let data = doc.data()
                    guard
                        let id = data["id"] as? String,
                        let email = data["email"] as? String,
                        let nickname = data["nickname"] as? String,
                        let postUploaded = data["postUploaded"] as? Bool,
                        let profileImageUrl = data["profileImageUrl"] as? String,
                        id != self.user.id
                    else {
                        return nil
                    }
                    return User(id: id, email: email, nickname: nickname, profileImageUrl: profileImageUrl, postUploaded: postUploaded)
                }
            }
    }
    
    /*
    func fetchFriendRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
                return
        }
            
        let userRef = db.collection("users").document(currentUserID)
            
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                
                // 보낸 친구 요청
                let sentRequests = (data?["sentRequests"] as? [[String: Any]] ?? []).compactMap { requestData in
                    FriendRequest(id: requestData["id"] as? String ?? "",
                    fromUserId: requestData["fromUserId"] as? String ?? "",
                    toUserId: requestData["toUserId"] as? String ?? "",
                    status: FriendRequestStatus(rawValue: requestData["status"] as? String ?? "") ?? .pending)
                }
                    
                // 받은 친구 요청
                let receivedRequests = (data?["receivedRequests"] as? [[String: Any]] ?? []).compactMap { requestData in
                    FriendRequest(id: requestData["id"] as? String ?? "",
                    fromUserId: requestData["fromUserId"] as? String ?? "",
                    toUserId: requestData["toUserId"] as? String ?? "",
                    status: FriendRequestStatus(rawValue: requestData["status"] as? String ?? "") ?? .pending)
                }
                    
                // user 객체 업데이트
                DispatchQueue.main.async {
                    self.user.sentRequests = sentRequests
                    self.user.receivedRequests = receivedRequests
                }
                    
            } else {
                print("User document does not exist")
            }
        }
    }
     */
    
    func isFriend(userId: String) -> Bool {
        return user.friends.contains(where: { $0.id == userId })
    }
    
    func sendFriendRequest (toUser: User) {
        guard !hasSentRequest(toUser: toUser) else {
            print("Friend request already sent")
            return
        }
        let requestId = UUID().uuidString
        let friendRequest = FriendRequest(
            id: requestId,
            fromUserId: user.id,
            toUserId: toUser.id,
            status: .pending,
            fromUserNick: user.nickname,
            fromUserImgUrl: user.profileImageUrl ?? "")
        
        self.user.sentRequests.append(friendRequest)
        
        db.collection("friendRequest").document(requestId).setData([
            "id": friendRequest.id,
            "fromUserId": friendRequest.fromUserId,
            "toUserId": friendRequest.toUserId,
            "status": friendRequest.status.rawValue,
        ]) { error in
            if let error = error {
                print("Error sending friend request: \(error)")
            } else {
                self.user.sentRequests.append(friendRequest)
                
                let userRef = self.db.collection("users").document(self.user.id)
                    userRef.updateData([
                        "sentRequests": FieldValue.arrayUnion([[
                        "id": friendRequest.id,
                        "fromUserId": friendRequest.fromUserId,
                        "toUserId": friendRequest.toUserId,
                        "status": friendRequest.status.rawValue,
                        ]])
                    ]) { error in
                        if let error = error {
                            print("Error updating sent requests: \(error)")
                    }
                }
                
                let toUserRef = self.db.collection("users").document(toUser.id)
                toUserRef.updateData([
                    "receivedRequests": FieldValue.arrayUnion([[
                        "id": friendRequest.id,
                        "fromUserId": friendRequest.fromUserId,
                        "toUserId": friendRequest.toUserId,
                        "status": friendRequest.status.rawValue,
                        "fromUserNick": friendRequest.fromUserNick,
                        "fromUserImgUrl": friendRequest.fromUserImgUrl
                    ]])
                ]) { error in
                    if let error = error {
                        print("Error updating received requests: \(error)")
                    }
                }
                self.createNotificationForFriendRequest(toUser: toUser)
            }
        }
    }
    
    private func createNotificationForFriendRequest(toUser: User) {
        let notificationMessage = "\(user.nickname)님이 친구 요청을 보냈습니다."
        db.collection("notifications").addDocument(data: [
            "message": notificationMessage,
            "timestamp": Timestamp(),
            "userId": toUser.id, // 알림을 받을 사용자 ID
            "fromUserId": user.id, // 요청 보낸 사용자 ID
            "notificationType": "friend_request",
            "isRead": false
        ]) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                print("Friend request notification added successfully.")
            }
        }
    }
    
    /*func acceptFriendRequest(request: FriendRequest) {
        let friendId = request.fromUserId
        let friendNickname = request.fromUserNick
        let friendProfileImageUrl = request.fromUserImgUrl
        
        // 수락 처리 로직
        db.collection("users").document(user.id).updateData([
            "friends": FieldValue.arrayUnion([[
                "id": friendId,
                "nickname": friendNickname,
                "profileImageUrl": friendProfileImageUrl
            ]])
        ]) { error in
            if let error = error {
                print("Error accepting friend request: \(error)")
            } else {
                self.db.collection("users").document(friendId).updateData([
                    "friends": FieldValue.arrayUnion([[
                        "id": self.user.id,
                        "nickname": self.user.nickname,
                        "profileImageUrl": self.user.profileImageUrl ?? ""
                    ]])
                ]) { error in
                    if let error = error {
                        print("Error updating friend's data: \(error)")
                    } else {
                        print("Friend request accepted successfully.")
                        
                        self.createNotificationForFriendAcceptance(friendId: friendId)
                    }
                }
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
    }*/
    
    func hasSentRequest(toUser user: User) -> Bool {
        return self.user.sentRequests.contains(where: { $0.toUserId == user.id && $0.status == .pending })
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
                "profileImageUrl": friend.profileImageUrl ?? ""
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
                "profileImageUrl": self.user.profileImageUrl ?? ""
            ]])
        ]) { error in
            if let error = error {
                print("Error removing friend from their list: \(error)")
            }
        }
    }
}
