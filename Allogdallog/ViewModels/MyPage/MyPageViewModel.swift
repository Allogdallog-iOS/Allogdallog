//
//  MyPageViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 9/20/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
//import FirebaseFirestoreSwift

class MyPageViewModel: ObservableObject {
    @Published var hasNewNotification: Bool = false
    @Published var isSignedOut: Bool = false
    @Published var notifications: [AppNotification] = []
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedOut = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func checkForNewNotifications(userId: String) {
        
        let db = Firestore.firestore()
        
        db.collection("notifications")
            .whereField("userId", isEqualTo: userId)
            //.whereField("isRead", isEqualTo: false)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
        if let error = error {
            print("Error fetching notifications: \(error.localizedDescription)")
            return
        }
                
            guard let documents = snapshot?.documents else {
                    print("No documents found for userId: \(userId)")
                DispatchQueue.main.async {
                    self.hasNewNotification = false
                }
                    return
                }
                
        print("Documents found: \(documents.count)")
                
        let lastNotification = documents[0].data()
        let isRead = lastNotification["isRead"] as? Bool ?? true
                
        DispatchQueue.main.async {
            self.hasNewNotification = !isRead
            print("New notification detected, setting hasNewNotification to \(self.hasNewNotification)")
                }
        }
    }
}
