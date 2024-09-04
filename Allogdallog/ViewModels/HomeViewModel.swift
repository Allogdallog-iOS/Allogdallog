//
//  HomeViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/23/24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var user: User
    @Published var isImagePickerPresented: Bool = false
    @Published var todayImage: UIImage? = nil
    @Published var todayComment: String = ""
    @Published var todayColor: String = ""
    @Published var selectedColor: Color = Color.red
    @Published var errorMessage: String? = nil
    @Published var friendPostUploaded: Bool = false
    @Published var friendImage: UIImage? = nil
    @Published var friendComment: String = ""
    @Published var friendColor: String = ""
    @Published var friendSelectedColor: Color = Color.red
    
    //@Published var postUploaded: Bool = false
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
        fetchPost()
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        guard let dateString = formatter.string(for: Date()) else { return "Date Error" }
        return dateString
    }
    
    func fetchPost() {
        let postRef = db.collection("posts/\(self.user.id)/\(getDate())").document(getDate())
        
        postRef.getDocument { document, error in
            if let document = document, document.exists {
                
                self.user.postUploaded = true
                let data = document.data()
                
                self.loadImageFromFirebase(selectedUserId: self.user.id) { image in
                    if let downloadedImage = image {
                        self.todayImage = downloadedImage
                    } else {
                        
                    }
                }
                
                self.todayColor = data?["todayColor"] as? String ?? ""
                self.todayComment = data?["todayComment"] as? String ?? ""
                self.selectedColor = Color(hex: self.todayColor)
                
            } else {
                self.user.postUploaded = false
            }
        }
    }
    
    func fetchFriendPost() {
        let postRef = db.collection("posts/\(self.user.selectedUser)/\(getDate())").document(getDate())
        
        postRef.getDocument { document, error in
            if let document = document, document.exists {
                
                self.friendPostUploaded = true
                let data = document.data()
                
                self.loadImageFromFirebase(selectedUserId: self.user.selectedUser) { image in
                    if let downloadedImage = image {
                        self.friendImage = downloadedImage
                    } else {
                        return
                    }
                }
                
                self.friendColor = data?["todayColor"] as? String ?? ""
                self.friendComment = data?["todayComment"] as? String ?? ""
                self.friendSelectedColor = Color(hex: self.friendColor)
                
            } else {
                self.friendPostUploaded = false
            }
        }
    }
    
    func uploadPost() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        todayColor = selectedColor.toHextString()
        
        guard todayImage != nil, !todayComment.isEmpty, !todayColor.isEmpty else {
            errorMessage = "모든 항목을 기입해주세요"
            return
        }
        
        
        let todayPostId = UUID().uuidString
        
        let userPostRef =  self.db.collection("posts/\(self.user.id)/\(getDate())").document(getDate())
        
        guard let todayImageToUpload = todayImage else { return  }
        
        self.uploadTodayImage(uid: currentUserId, image: todayImageToUpload) { url in
            guard let url = url else {
                self.errorMessage = "프로필 이미지 등록에 실패했습니다"
                return
            }
            
            userPostRef.setData([
                "id": todayPostId,
                "todayImageUrl": url.absoluteString,
                "todayColor": self.todayColor,
                "todayComment" : self.todayComment
            ])
        }
    }
    
    private func uploadTodayImage(uid: String, image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8)
        else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("post_images/\(uid)").child(getDate())
        
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
    
    func loadImageFromFirebase(selectedUserId: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "post_images/\(selectedUserId)/\(getDate())")
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
            completion(nil)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
            
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHextString() -> String {
        guard let components = cgColor?.components else {
            return ""
        }
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

struct CustomTextEditor: View {
    @Binding var text: String
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text("하루를 기록하세요")
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.6)
                    Spacer()
                }
            }
            VStack {
                TextEditor(text: $text)
                    .opacity(text.isEmpty ? 0.85 : 1)
                Spacer()
            }
        }
    }
}


