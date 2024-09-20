import Foundation
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user: User?
    private var db = Firestore.firestore()
    
    func fetchUser(userId: String) {
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                
                let id = data?["id"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let nickname = data?["nickname"] as? String ?? ""
                let profileImageUrl = data?["profileImageUrl"] as? String ?? ""
                let postUploaded = data?["postUploaded"] as? Bool ?? false
                let selectedUser = data?["selectedUser"] as? String ?? ""
                
                let friends = (data?["friends"] as? [[String: Any]] ?? []).compactMap { friendData in
                    Friend(id: friendData["id"] as? String ?? "",
                    nickname: friendData["nickname"] as? String ?? "",
                    profileImageUrl: friendData["profileImageUrl"] as? String ?? "")
                }
                
                let sentRequests = (data?["sentRequests"] as? [[String: Any]] ?? []).compactMap { requestData in
                    FriendRequest(id: requestData["id"] as? String ?? "",
                    fromUserId: requestData["fromUserId"] as? String ?? "",
                    toUserId: requestData["toUserId"] as? String ?? "",
                    status: FriendRequestStatus(rawValue: requestData["status"] as? String ?? "") ?? .pending,
                    fromUserNick: requestData["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: requestData["fromUserImgUrl"] as? String ?? "")
                }
                
                let receivedRequests = (data?["receivedRequests"] as? [[String: Any]] ?? []).compactMap { requestData in
                    FriendRequest(id: requestData["id"] as? String ?? "",
                    fromUserId: requestData["fromUserId"] as? String ?? "",
                    toUserId: requestData["toUserId"] as? String ?? "",
                    status: FriendRequestStatus(rawValue: requestData["status"] as? String ?? "") ?? .pending,
                    fromUserNick: requestData["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: requestData["fromUserImgUrl"] as? String ?? "")
                }
                
                self.user = User (
                    id: id,
                    email: email,
                    nickname: nickname,
                    profileImageUrl: profileImageUrl,
                    friends: friends,
                    sentRequests: sentRequests,
                    receivedRequests: receivedRequests,
                    postUploaded: postUploaded,
                    selectedUser: selectedUser
                )
                
            } else {
                print("User does not exist")
            }
        }
    }
}
