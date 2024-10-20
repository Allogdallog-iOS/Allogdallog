//
//  SignUpViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Combine
import UIKit

class SignUpViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var nickname: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isImagePickerPresented: Bool = false
    @Published var signUpComplete: Bool = false
    
    private var db = Firestore.firestore()
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !nickname.isEmpty else {
            errorMessage = "모든 항목을 기입해주세요"
            return
        }
        
        let defaultProfileImage = UIImage(systemName: "person.crop.circle.fill")!.withTintColor(.myLightGray, renderingMode: .alwaysOriginal)
        let resizedProfileImage = resizeImage(image: defaultProfileImage, targetSize: CGSize(width: 200, height: 200))
        let profileImageToUpload = profileImage ?? resizedProfileImage
        
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            self?.uploadProfileImage(uid: uid, image: profileImageToUpload) { url in
                guard let url = url else {
                    self?.errorMessage = "프로필 이미지 등록에 실패하였습니다"
                    return
                }
                
                let user = User(id: uid, email: self?.email ?? "", nickname: self?.nickname ?? "", profileImageUrl: url.absoluteString, friends: [], postUploaded: false, selectedUser: uid)
                self?.saveUserToFirestore(user: user)
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self?.nickname
                changeRequest?.photoURL = url
                changeRequest?.commitChanges() { error in
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else {
                        //회원가입 완료
                        self?.signUpComplete = true
                    }
                }
            }
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
    
    private func uploadProfileImage(uid: String, image: UIImage, completion: @escaping (URL?) -> Void) {
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
    
    private func saveUserToFirestore(user: User) {
        do {
            try db.collection("users").document(user.id).setData(from: user)
        } catch let error {
            print("Error writing user to Firestore: \(error.localizedDescription)")
        }
    }
}
