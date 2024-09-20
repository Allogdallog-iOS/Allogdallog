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
    @Published var todayPost: Post
    @Published var todayImage: UIImage? = nil
    @Published var selectedColor: Color = Color.red
    @Published var errorMessage: String? = nil
    @Published var friendPostUploaded: Bool = false
    @Published var friendPost: Post
    @Published var friendImage: UIImage? = nil
    @Published var friendSelectedColor: Color = Color.red
    @Published var postButtonsDisabled: Bool = false
    @Published var myComment: String = ""
    //@Published var postUploaded: Bool = false
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
        self.todayPost = Post()
        self.friendPost = Post()
        fetchPost()
    }
    
    func fetchPost() {
        let postRef = db.collection("posts/\(self.user.id)/\(getDate())").document(getDate())
        
        postRef.getDocument { document, error in
            if let document = document, document.exists {
                
                self.user.postUploaded = true
                self.postButtonsDisabled = true
                let data = document.data()
                
                self.loadImageFromFirebase(selectedUserId: self.user.id) { image in
                    if let downloadedImage = image {
                        self.todayImage = downloadedImage
                    } else {
                        
                    }
                }
                
                self.todayPost.id = data?["id"] as? String ?? ""
                self.todayPost.todayColor = data?["todayColor"] as? String ?? ""
                self.todayPost.todayText = data?["todayText"] as? String ?? ""
                self.todayPost.todayComments = (data?["todayComments"] as? [[String: Any]] ?? []).compactMap { comment in
                    Comment(id: comment["id"] as? String ?? "",
                    fromUserNick: comment["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: comment["fromUserImgUrl"] as? String ?? "",
                    comment: comment["comment"] as? String ?? "")
                }
                
                self.selectedColor = Color(hex: self.todayPost.todayColor)
                
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
                
                self.friendPost.todayColor = data?["todayColor"] as? String ?? ""
                self.friendPost.todayText = data?["todayText"] as? String ?? ""
                self.friendPost.todayComments = (data?["todayComments"] as? [[String: Any]] ?? []).compactMap { comment in
                    Comment(id: comment["id"] as? String ?? "",
                    fromUserNick: comment["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: comment["fromUserImgUrl"] as? String ?? "",
                    comment: comment["comment"] as? String ?? "")
                }
                self.friendSelectedColor = Color(hex: self.friendPost.todayColor)
                
            } else {
                self.friendPostUploaded = false
            }
        }
    }
    
    func uploadPost() {
        self.postButtonsDisabled = true
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        self.todayPost.todayColor = selectedColor.toHextString()
        
        guard self.todayImage != nil, !self.todayPost.todayText.isEmpty, !self.todayPost.todayColor.isEmpty else {
            errorMessage = "모든 항목을 기입해주세요"
            return
        }
        
        
        let todayPostId = UUID().uuidString
        
        let userPostRef =  self.db.collection("posts/\(self.user.id)/\(getDate())").document(getDate())
        
        guard let todayImageToUpload = todayImage else { return }
        
        self.uploadTodayImage(uid: currentUserId, image: todayImageToUpload) { success in
            if !success {
                self.errorMessage = "이미지 등록에 실패했습니다"
                return
            }
            
            if self.user.postUploaded {
                userPostRef.updateData([
                    "todayColor": self.todayPost.todayColor,
                    "todayText": self.todayPost.todayText,
                    "todayComments": self.todayPost.todayComments
                ])
            } else {
                userPostRef.setData([
                    "id": todayPostId,
                    "todayColor": self.todayPost.todayColor,
                    "todayText": self.todayPost.todayText,
                    "todayComments": self.todayPost.todayComments
                    
                ])
            }
        }
    }
    
    func uploadComment() {
        let userPostRef =  self.db.collection("posts/\(self.user.selectedUser)/\(getDate())").document(getDate())
        
        let commentId = UUID().uuidString
        let newComment = Comment(id: commentId, fromUserNick: self.user.nickname, fromUserImgUrl: self.user.profileImageUrl ?? "", comment: myComment)
        
        self.friendPost.todayComments.append(newComment)
        
        userPostRef.updateData([
            "todayComments": FieldValue.arrayUnion([[
                "id": commentId,
                "fromUserNick": self.user.nickname,
                "fromUserImgUrl": self.user.profileImageUrl ?? "",
                "comment": myComment
            ]])
        ])
    }
    
    private func uploadTodayImage(uid: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8)
        else {
            completion(false)
            return
        }
        
        let storageRef = Storage.storage().reference().child("post_images/\(uid)").child(getDate())
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Failed to upload image: \(error)")
                completion(false)
                return
            }
            completion(true)
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
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        guard let dateString = formatter.string(for: Date()) else { return "Date Error" }
        return dateString
    }
    
    func getWeekDates() -> [String ] {
        let calendar = Calendar.current
        let today = Date()
        
        let weekdat = calendar.component(.weekday, from: today)
        let weekStartDate = calendar.date(byAdding: .day, value: -(weekdat - 2), to: today)!
        
        var weekDates: [Date] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStartDate) {
                weekDates.append(date)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let weekDatesString: [String] = weekDates.map(formatter.string)
        return weekDatesString
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


