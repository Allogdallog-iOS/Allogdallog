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
    @Published var selectedDate: String = ""
    @Published var selectedColor: Color = Color.blue
    @Published var selectedKeyword: String = "기쁨"
    @Published var selectedEmoji: String = "😊"
    @Published var errorMessage: String? = nil
    @Published var friendPostUploaded: Bool = false
    @Published var friendPost: Post
    @Published var pastFriendPost: Post
    @Published var friendImage: UIImage? = nil
    @Published var postButtonsDisabled: Bool = false
    @Published var myComment: String = ""
    @Published var isColorPaletteOpen: Bool = false
    @Published var isEmojiPaletteOpen: Bool = false
    @Published var paletteKeys: [String] = ["기쁨", "차분", "슬픔", "커스텀"]
    @Published var colorPalettes: [String: [Color]] = [
        "기쁨": [.yellow, .orange, .pink, .green, .mint],
        "차분": [.blue, .teal, .purple, .brown],
        "슬픔": [.black, .gray, .blue, .indigo],
        "커스텀": []
    ]
    @Published var emojiPalettes: [String: [String]] = [
        "기쁨": ["😊","😀", "😄", "😆", "😝"],
        "차분": ["🙂", "😐", "🙃", "🫠", "😴"],
        "슬픔": ["🥲", "😭", "😱", "🤕", "😵‍💫"],
        "커스텀": []
    ]
    @Published var notifications: [AppNotification] = []
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
        self.todayPost = Post()
        self.friendPost = Post()
        self.pastFriendPost = Post()
        self.colorPalettes["커스텀"] = self.user.myColors.map { Color(hex: $0) }
        self.emojiPalettes["커스텀"] = self.user.myEmojis
        fetchPost()
    }
    
    func fetchPost() {
        let postRef = db.collection("posts/\(self.user.id)/posts").document(getTodayDateString())
        
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
                    Comment(id: comment["id"] as? String ?? "", fromUserId: comment["fromUserId"] as? String ?? "",
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
                self.selectedEmoji = self.todayPost.todayText
                
            } else {
                self.user.postUploaded = false
            }
        }
    }
    
    func fetchFriendPost(date: String) {
        let postRef = db.collection("posts/\(self.user.selectedUser)/posts").document(date)
        
        self.friendPost = Post()

        postRef.getDocument { document, error in
            if let document = document, document.exists {
                
                self.friendPostUploaded = true
                let data = document.data()
                
                self.friendPost.id = data?["id"] as? String ?? ""
                self.friendPost.todayImgUrl = data?["todayImgUrl"] as? String ?? ""
                self.friendPost.todayColor = data?["todayColor"] as? String ?? ""
                self.friendPost.todayText = data?["todayText"] as? String ?? ""
                self.friendPost.todayComments = (data?["todayComments"] as? [[String: Any]] ?? []).compactMap { comment in
                    Comment(id: comment["id"] as? String ?? "", fromUserId: comment["fromUserId"] as? String ?? "",
                    fromUserNick: comment["fromUserNick"] as? String ?? "",
                    fromUserImgUrl: comment["fromUserImgUrl"] as? String ?? "",
                    comment: comment["comment"] as? String ?? "")
                }
                
            } else {
                self.friendPostUploaded = false
            }
        }
    }
    
    func uploadPost() {
        self.todayPost.todayDate = Date()
        self.todayPost.todayColor = selectedColor.toHextString()
        self.todayPost.todayText = selectedEmoji
        
        let userPostRef =  self.db.collection("posts/\(self.user.id)/posts").document(getTodayDateString())
    
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        guard self.todayImage != nil, !self.todayPost.todayText.isEmpty, !self.todayPost.todayColor.isEmpty else {
            errorMessage = "모든 항목을 기입해주세요"
            return
        }
    
        self.postButtonsDisabled = true
        
        let todayPostId = UUID().uuidString
        
        guard let todayImageToUpload = todayImage else { return }
        
        self.uploadImage(uid: currentUserId, image: todayImageToUpload) { url in
            guard let url = url else {
                self.errorMessage = "이미지 등록에 실패했습니다."
                return
            }
            
            self.todayPost.todayImgUrl = url.absoluteString
            
            if self.user.postUploaded {
                userPostRef.updateData([
                    "todayImgUrl": url.absoluteString,
                    "todayColor": self.todayPost.todayColor,
                    "todayText": self.todayPost.todayText,
                    "todayComments": self.todayPost.todayComments
                ])
            } else {
                self.user.postUploaded = true
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
    
    func uploadComment(date: String) {
        let userPostRef =  self.db.collection("posts/\(self.user.selectedUser)/posts").document(date)
        
        userPostRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Post does not exist")
                return
            }
            let postOwnerId = document.data()?["userId"] as? String ?? self.friendPost.userId
            
            let commentId = UUID().uuidString
            let newComment = Comment(id: commentId, fromUserId: self.user.id, fromUserNick: self.user.nickname, fromUserImgUrl: self.user.profileImageUrl ?? "", comment: self.myComment)
            
            self.friendPost.todayComments.append(newComment)
            
            userPostRef.updateData([
                "todayComments": FieldValue.arrayUnion([[
                    "id": commentId,
                    "fromUserNick": self.user.nickname,
                    "fromUserImgUrl": self.user.profileImageUrl ?? "",
                    "comment": self.myComment
                ]])
            ]){ error in
                if let error = error {
                    print("Error adding comment: \(error)")
                } else {
                    print("Post owner ID: \(postOwnerId)") // 포스트 소유자 ID 로그 추가
                    self.createNotification(forComment: newComment, postOwnerId: postOwnerId)
                }
            }
            
            self.myComment = ""
        }
    }
    
    private func createNotification(forComment comment: Comment, postOwnerId: String) {
        let notificationMessage = "\(comment.fromUserNick)님이 댓글 \"\(comment.comment)\"을 남겼습니다."
        
        print("Adding notification for userId: \(postOwnerId)")
        
        db.collection("notifications").addDocument(data: [
            "message": notificationMessage,
            "timestamp": Timestamp(),
            "userId": postOwnerId, // 알림을 수신할 사용자 ID
            "fromUserId": comment.fromUserId, // 댓글 작성자 ID
            "notificationType": "comment"
        ]) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                print("Notification added successfully.")
            }
        }
    }
    
    func listenForNotifications() {
        db.collection("notifications").whereField("userId", isEqualTo: self.user.id)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error listening for notifications: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return }
                
                self.notifications = []
                print("Found \(documents.count) notifications")
                
                for document in documents {
                    let data = document.data()
                    
                    print("Document data: \(data)")
                    
                    let message = data["message"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                    let fromUserId = data["fromUserId"] as? String ?? ""
                    let notificationType = data["notificationType"] as? String ?? ""
                
                    let notification = AppNotification(
                        message: message,
                        timestamp: timestamp.dateValue(),
                        fromUserId: fromUserId,
                        notificationType: notificationType
                    )
                    self.notifications.append(notification)
                    
                    // 추가된 알림 확인용 로그
                    print("New notification received: \(notification)")
                }
            }
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
            
        let storageRef = Storage.storage().reference().child("post_images/\(uid)").child(getTodayDateString())
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if self.user.postUploaded {
            storageRef.delete { error in
                if let error = error {
                    print("Error deleting file: \(error)")
                } else {
                    print("File deleted successfully")
                }
            }
        }
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
    
    func addMyNewColor(color: String) {
        let userRef =  self.db.collection("users").document(self.user.id)
        
        if !self.user.myColors.contains(color) {
            self.colorPalettes["커스텀"]?.append(Color(hex:color))
            self.user.myColors.append(color)
                
            userRef.updateData([
                "myColors": self.user.myColors
            ])
        } else {
            print("이미 있는 색상입니다.")
        }
    }
    
    func addMyNewEmoji(emoji: String) {
        let userRef =  self.db.collection("users").document(self.user.id)
        
        if !self.user.myEmojis.contains(emoji) {
            self.emojiPalettes["커스텀"]?.append(emoji)
            self.user.myEmojis.append(emoji)
            
            userRef.updateData([
                "myEmojis": self.user.myEmojis
            ])
        } else {
            print("이미 있는 이모지입니다.")
        }
    }
    
    func isEqualWithSelectedId() -> Bool {
        if self.user.selectedUser == self.user.id {
            return true
        } else {
            return false
        }
    }

    func getTodayDateString() -> String {
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
        let uiColor = UIColor(self)
        guard let components = uiColor.cgColor.components else {
            return ""
        }
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

extension Character {
    var isEmoji: Bool {
        return unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
}

struct CustomTextEditor: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text("😀")
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.5)
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


