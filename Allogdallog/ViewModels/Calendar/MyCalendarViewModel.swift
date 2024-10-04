//
//  MyCalendarViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 9/20/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class MyCalendarViewModel: ObservableObject {
    
    @Published var month: Date
    @Published var offset: CGSize = CGSize()
    @Published var clickedDates: Set<Date> = []
    @Published var selectedUserId: String
    @Published var recoredPosts: [Post] = []
    @Published var posts: [Date: [Post]] = [:]
    @Published var readingPost: Post?
    
    private var db = Firestore.firestore()
    
    init(selectedUserId: String) {
        self.selectedUserId = selectedUserId
        self.month = Date()
        fetchPostForMonth(self.month)
    }
    
    func fetchPostForMonth(_ date: Date) {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self.month)
        let month = calendar.component(.month, from: self.month)
        
        let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
        
        fetchPostsDate(from: startDate, to: endDate) { [weak self] posts in
            DispatchQueue.main.async {
                self?.posts = posts
            }
        }
    }
    
    func fetchPostsDate(from startDate: Date, to endDate: Date, completion: @escaping([Date: [Post]]) -> Void) {
        let postRef = db.collection("posts").document(self.selectedUserId).collection("posts")
        
        postRef
            .whereField("todayDate", isGreaterThanOrEqualTo: startDate)
            .whereField("todayDate", isLessThan: endDate)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([:])
                    return
                }
                
                var posts: [Date: [Post]] = [:]
                
                for document in documents {
                    let post = Post(id: document.documentID, data: document.data())
                    let postDate = Calendar.current.startOfDay(for: post.todayDate)
                    
                    if posts[postDate] != nil {
                        posts[postDate]?.append(post)
                    } else {
                        posts[postDate] = [post]
                    }
                }
                completion(posts)
            }
    }
    
    func formateDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy..M.d"
        return dateFormatter.string(from: date)
    }
    
    func loadImageFromFirebase(selectedUserId: String, date: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "post_images/\(selectedUserId)/\(date)")
        
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
    
    func hasPosts(for date: Date) -> Bool {
        return posts[date] != nil && !(posts[date]?.isEmpty ?? true)
    }
    
    func getPosts(for date: Date) -> [Post]? {
        return posts[date]
    }
        
    func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
        
    }
    
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    func numberOfDays(in month: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
            fetchPostForMonth(self.month)
        }
    }
}

extension MyCalendar {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    static let weekdaySymbols = Calendar.current.shortWeekdaySymbols
}
