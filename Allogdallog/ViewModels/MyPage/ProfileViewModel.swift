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
                //existingUser.nickname = self.nickname
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
                        self.nickname = self.nickname // 최신 닉네임 반영
                        self.signUpComplete = true
                    }
                }
                
                
            }
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
    

