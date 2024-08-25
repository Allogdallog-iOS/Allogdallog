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

class HomeViewModel: ObservableObject {
    
    @Published var user: User
    @Published var selectedUserId: String = ""
    @Published var todayPost: Post?
    @Published var selectedPost: Post?
    //@Published var postUploaded: Bool = false
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        guard let dateString = formatter.string(for: Date()) else { return "Date Error" }
        return dateString
    }
    
    func fetchPost(selectedUserId: String) async {
        
        let postRef = db.collection("posts/\(selectedUserId)").document(getDate())
        
        do {
            let document = try await postRef.getDocument()
            if document.exists {
                self.user.postUploaded = true
                
                if let data = document.data() {
                    let id = data["id"] as? String ?? ""
                    let todayImageUrl = data["todayImageUrl"] as? String ?? ""
                    let todayColor = data["todayColor"] as? String ?? ""
                    let todayComment = data["todayComment"] as? String ?? ""
                    
                    self.selectedPost = Post (
                        id: id,
                        todayImageUrl: todayImageUrl,
                        todayColor: todayColor,
                        todayComment: todayComment
                    )
                }
                
            } else {
                self.user.postUploaded = false
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
    
    func uploadPost(todayPost: Post) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }
        
        let userPostRef =  db.collection("posts/\(currentUserId)").document(getDate())
        
        userPostRef.setData([
            "id": todayPost.id,
            "todayImageUrl": todayPost.todayImageUrl,
            "todayColor": todayPost.todayColor,
            "todayComment" : todayPost.todayComment
        ])
        
    }
    
}
