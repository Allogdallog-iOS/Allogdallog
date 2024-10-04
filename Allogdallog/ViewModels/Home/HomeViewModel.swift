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
        let postRef = db.collection("posts/\(self.user.id)/posts").document(getDate())
        
        postRef.getDocument { document, error in
            if let document = document, document.exists {
                
                self.user.postUploaded = true
                self.postButtonsDisabled = true
                let data = document.data()
                
                self.todayPost.id = data?["id"] as? String ?? ""
                self.todayPost.todayDate = data?["todayDate"] as? Date ?? Date()
                self.todayPost.todayImgUrl = data?["todayImgUrl"] as? String ?? ""
                self.todayPost.todayColor = data?["todayColor"] as? String ?? ""
                self.todayPost.todayText = data?["todayText"] as? String ?? ""
                self.todayPost.todayComments = (data?["todayComments"] as? [[String: Any]] ?? []).compactMap { comment in
                    Comment(id: comment["id"] as? String ?? "",
                    fromUserNick: comment["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: comment["fromUserImgUrl"] as? String ?? "",
                    comment: comment["comment"] as? String ?? "")
                }
                
                self.fetchImage(from: self.todayPost.todayImgUrl) { image in
                    if let image = image {
                        self.todayImage = image
                    } else {
                        print("Failed to load image")
                    }
                }
                
                self.selectedColor = Color(hex: self.todayPost.todayColor)
                
            } else {
                self.user.postUploaded = false
            }
        }
    }
    
    func fetchFriendPost() {
        let postRef = db.collection("posts/\(self.user.selectedUser)/posts").document(getDate())
        
        postRef.getDocument { document, error in
            if let document = document, document.exists {
                
                self.friendPostUploaded = true
                let data = document.data()
                
                self.friendPost.todayImgUrl = data?["todayImgUrl"] as? String ?? ""
                self.friendPost.todayColor = data?["todayColor"] as? String ?? ""
                self.friendPost.todayText = data?["todayText"] as? String ?? ""
                self.friendPost.todayComments = (data?["todayComments"] as? [[String: Any]] ?? []).compactMap { comment in
                    Comment(id: comment["id"] as? String ?? "",
                    fromUserNick: comment["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: comment["fromUserImgUrl"] as? String ?? "",
                    comment: comment["comment"] as? String ?? "")
                }
                self.friendSelectedColor = Color(hex: self.friendPost.todayColor)
                
                self.fetchImage(from: self.friendPost.todayImgUrl) { image in
                    if let image = image {
                        self.todayImage = image
                    } else {
                        print("Failed to load image")
                    }
                }
                
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
        
        self.todayPost.todayDate = Date()
        self.todayPost.todayColor = selectedColor.toHextString()
        
        guard self.todayImage != nil, !self.todayPost.todayText.isEmpty, !self.todayPost.todayColor.isEmpty else {
            errorMessage = "모든 항목을 기입해주세요"
            return
        }
        
        let todayPostId = UUID().uuidString
        
        let userPostRef =  self.db.collection("posts/\(self.user.id)/posts").document(getDate())
        
        guard let todayImageToUpload = todayImage else { return }
        
        self.uploadImage(uid: currentUserId, image: todayImageToUpload) { url in
            guard let url = url else {
                self.errorMessage = "이미지 등록에 실패했습니다."
                return
            }
            
            if self.user.postUploaded {
                userPostRef.updateData([
                    "todayImgUrl": url.absoluteString,
                    "todayColor": self.todayPost.todayColor,
                    "todayText": self.todayPost.todayText,
                    "todayComments": self.todayPost.todayComments
                ])
            } else {
                userPostRef.setData([
                    "id": todayPostId,
                    "todayDate": self.todayPost.todayDate,
                    "todayImgUrl": url.absoluteString,
                    "todayColor": self.todayPost.todayColor,
                    "todayText": self.todayPost.todayText,
                    "todayComments": self.todayPost.todayComments
                ])
            }
        }
    }
    
    func uploadComment() {
        let userPostRef =  self.db.collection("posts/\(self.user.selectedUser)/posts").document(getDate())
        
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
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    private func uploadImage(uid: String, image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
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

    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
        guard let dateString = formatter.string(for: Date()) else { return "Date Error" }
        return dateString
    }
    
    func getWeekDates() -> [String] {
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


