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
        fetchFriendRequests()
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
                        let nickname = data["nickname"] as? String
                    else {
                        return nil
                    }
                    let profileImageUrl = data["profileImageUrl"] as? String
                    let friendsData = data["friends"] as? [[String: Any]] ?? []
                    let friends = friendsData.compactMap { Friend(id: $0["id"] as! String, nickname: $0["nickname"] as! String, postUploaded: $0["postUploaded"] as! Bool, profileImageUrl: $0["profileImageUrl"] as? String ?? "") }
                    return User(id: id, email: email, nickname: nickname, profileImageUrl: profileImageUrl, friends: friends)
                }
            }
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
    
    func sendFriendRequest (toUser: User) {
        let requestId = UUID().uuidString
        let friendRequest = FriendRequest(id: requestId, fromUserId: user.id, toUserId: toUser.id, status: .pending)
        
        db.collection("friendRequest").document(requestId).setData([
            "id": friendRequest.id,
            "fromUserId": friendRequest.fromUserId,
            "toUserId": friendRequest.toUserId,
            "status": friendRequest.status.rawValue
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
                        "status": friendRequest.status.rawValue
                        ]])
                    ]) { error in
                        if let error = error {
                            print("Error updating sent requests: \(error)")
                    }
                }
            }
        }
    }
    
    func hasSentRequest(toUser user: User) -> Bool {
        return user.sentRequests.contains(where: { $0.toUserId == user.id && $0.status == .pending })
    }
}
