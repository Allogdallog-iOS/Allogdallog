//
//  ProfileViewModel.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    
    @Published var user: User
    @Published var profileImage: UIImage?
    @Published var isImagePickerPresented: Bool = false
    @Published var nickname: String = ""
    @Published var errorMessage: String? = nil
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var signUpComplete: Bool = false
    @Published var friends: [Friend] = []
    @Published var sentRequests: [FriendRequest] = []
    @Published var receivedRequests: [FriendRequest] = []
    @Published var postUploaded: Bool = false
    @Published var selectedUser: String = ""
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
        self.nickname = user.nickname
        self.fetchFriendsData()
    }
    
    
    func editProfileUpload() {
        guard !nickname.isEmpty else {
            print("Nickname cannot be empty")
            return
        }
        guard let uid = Auth.auth().currentUser?.uid, !uid.isEmpty else {
            print("User ID is empty or invalid.")
            return
        }
        // 현재 사용자의 UID 가져오기
        /* guard let uid = Auth.auth().currentUser?.uid else {
            print("User is not logged in or uid not found")
            return
        }*/
        
        let defaultProfileImage = UIImage(systemName: "person.circle.fill")!.withTintColor(.myLightGray, renderingMode: .alwaysOriginal)
        let resizedProfileImage = resizeImage(image: defaultProfileImage, targetSize: CGSize(width: 200, height: 200))
        let profileImageToUpload = profileImage ?? resizedProfileImage
        
        
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            guard let self = self, error == nil, let document = document, document.exists else {
                self?.errorMessage = "사용자 정보를 찾을 수 없습니다."
                return
            }
            
            // Firestore에서 불러온 데이터를 Friend 객체로 변환
                let friendsData = document.get("friends") as? [[String: Any]] ?? []
                let friends = friendsData.compactMap { Friend(dictionary: $0) }
                
                let sentRequestsData = document.get("sentRequests") as? [[String: Any]] ?? []
                let sentRequests = sentRequestsData.compactMap { FriendRequest(dictionary: $0) }
                
                let receivedRequestsData = document.get("receivedRequests") as? [[String: Any]] ?? []
                let receivedRequests = receivedRequestsData.compactMap { FriendRequest(dictionary: $0) }
            
            var existingUser = User(
                id: uid,
                email: document.get("email") as? String ?? "",
                nickname: self.nickname, // 닉네임을 여기에서 업데이트
                    //document.get("nickname") as? String ?? "",
                profileImageUrl: document.get("profileImageUrl") as? String ?? "",
                friends: friends, // 변환된 Friend 배열
                sentRequests: sentRequests, // 변환된 FriendRequest 배열
                receivedRequests: receivedRequests, // 변환된 FriendRequest 배열
                postUploaded: document.get("postUploaded") as? Bool ?? false,
                selectedUser: document.get("selectedUser") as? String ?? uid
            )
            
            
            self.editProfile(uid: uid, image: profileImageToUpload) { [weak self] url in
                guard let self = self else { return }
                guard let url = url else {
                    self.errorMessage = "프로필 이미지 등록에 실패하였습니다"
                    return
                }
                
                // Firestore에 사용자 정보 저장
                /* let updatedUser = User(id: uid, email: self?.email ?? "", nickname: self?.nickname ?? "", profileImageUrl: url.absoluteString, friends: [], postUploaded: false, selectedUser: uid)
                 self?.saveProfileToFirestore(user: updatedUser)*/
                
                // 사용자 정보 업데이트
                existingUser.nickname = self.nickname
                existingUser.profileImageUrl = url.absoluteString
                self.saveProfileToFirestore(user: existingUser)
                
                // Firebase Auth 프로필 업데이트
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.nickname
                changeRequest?.photoURL = url
                changeRequest?.commitChanges() { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        // 수정 완료 후 User 객체도 업데이트
                        self.user = existingUser
                        // 추가: UserDefaults 또는 별도의 모델을 통해 닉네임을 저장
                        self.user.nickname = self.nickname // 최신 닉네임 반영
                        self.signUpComplete = true
                       
                        // 프로필 업데이트가 성공적으로 완료되면 모든 사용자들의 친구 목록에서 닉네임을 업데이트
                        self.updateFriendNicknameForAllUsers(friendId: self.user.id, newNickname: self.nickname)
                    }
                }
                
                
            }
        }
    }
    
        func updateFriendNickname(friendId: String, newNickname: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
            
        
        let userRef = db.collection("users").document(uid)
           
            // 친구 배열에서 해당 친구의 닉네임 업데이트
        if let index = friends.firstIndex(where: { $0.id == friendId }) {
                    friends[index].nickname = newNickname // 뷰 갱신을 위해 friends 배열 업데이트
                }
            
        userRef.updateData([
            "friends": FieldValue.arrayRemove([Friend(id: friendId, nickname: "", profileImageUrl: "").toDictionary()]),
            "friends": FieldValue.arrayUnion([Friend(id: friendId, nickname: newNickname, profileImageUrl: "").toDictionary()])
        ]) { error in
            if let error = error {
                print("Error updating nickname: \(error.localizedDescription)")
            } else {
                print("닉네임 업데이트 성공!")
                self.fetchFriendsData() // 업데이트 후 실시간 데이터 다시 불러오기
            }
        }
    }
    
    func updateFriendNicknameForAllUsers(friendId: String, newNickname: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Firestore에서 "users" 컬렉션에 있는 모든 문서를 가져옴
        db.collection("users").getDocuments { [weak self] snapshot, error in
            guard let self = self, let documents = snapshot?.documents, error == nil else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let batch = self.db.batch() // Batch 시작

            for document in documents {
                let userId = document.documentID
                let friendsData = document.get("friends") as? [[String: Any]] ?? []

                // 해당 유저의 friends 필드에서 업데이트할 친구가 있는지 확인
                var updatedFriends = friendsData.compactMap { friendDict -> [String: Any]? in
                    var friend = friendDict
                    if let id = friend["id"] as? String, id == friendId {
                        // 닉네임 업데이트
                        friend["nickname"] = newNickname
                    }
                    return friend
                }
                
                // 만약 업데이트할 내용이 있으면 해당 문서의 friends 필드를 업데이트
                if !updatedFriends.isEmpty {
                    let userRef = self.db.collection("users").document(userId)
                    batch.updateData(["friends": updatedFriends], forDocument: userRef)
                }
            }
            
            // Batch 커밋
            batch.commit { error in
                if let error = error {
                    print("Error updating friends' nicknames: \(error.localizedDescription)")
                } else {
                    print("닉네임 업데이트 성공!")
                }
            }
        }
    }
    
        func fetchFriendsData() {
            
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching friends: \(error.localizedDescription)")
                return
            }

            guard let document = documentSnapshot, document.exists, let data = document.data() else {
                print("Document does not exist")
                return
            }

            let friendsData = data["friends"] as? [[String: Any]] ?? []
            let updatedFriends = friendsData.compactMap { Friend(dictionary: $0) }
            
            // 친구 목록 업데이트 (뷰 자동 갱신)
            self.friends = updatedFriends
        }
    }
        
        private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let resizedImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
            return resizedImage
        }
        
        private func editProfile(uid: String, image: UIImage, completion: @escaping (URL?) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(nil)
                return
            }
            
            let storageRef = Storage.storage().reference().child("profile_images").child(uid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    print("Failed to upload image: \(error)")
                    completion(nil)
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Failed to retrieve download URL: \(error)")
                        completion(nil)
                        return
                    }
                    completion(url)
                }
            }
        }
        
        // Firestore에 사용자 정보 저장 함수
        private func saveProfileToFirestore(user: User) {
            
            // ID가 올바른지 확인
                guard !user.id.isEmpty else {
                    print("User ID is missing.")
                    return
                }
            
            let userRef = db.collection("users").document(user.id)
            
            // Friend와 FriendRequest 객체를 toDictionary()로 변환
                let friendsData = user.friends.map { $0.toDictionary() }
                let sentRequestsData = user.sentRequests.map { $0.toDictionary() }
                let receivedRequestsData = user.receivedRequests.map { $0.toDictionary() }

            
            userRef.setData([
                "email": user.email,
                "friends": friendsData,  // 변환된 데이터
                "nickname": user.nickname,
                "postUploaded": user.postUploaded,
                "profileImageUrl": user.profileImageUrl,
                "receivedRequests": receivedRequestsData,  // 변환된 데이터
                "selectedUser": user.selectedUser,
                "sentRequests": sentRequestsData  // 변환된 데이터
            ], merge: true) { error in
                if let error = error {
                    print("Error saving profile data: \(error.localizedDescription)")
                } else {
                    print("프로필 수정 완료!")
                }
            }
            print("Saving user data: \(user)")
        }
    func createPath(components: String...) -> String {
            return components
                .filter { !$0.isEmpty }  // 빈 문자열 필터링
                .joined(separator: "/")
                .replacingOccurrences(of: "//", with: "/")
        }
    }
    

