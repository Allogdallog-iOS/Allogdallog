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
    
    @Published var user: User
    @Published var month: Date
    @Published var offset: CGSize = CGSize()
    @Published var recoredPosts: [Post] = []
    @Published var posts: [Date: [Post]] = [:]
    @Published var readingPost: Post?
    @Published var clickedPost: Post?
    @Published var weekPosts: [Post] = []
    
    private var db = Firestore.firestore()
    
    init(user: User) {
        self.user = user
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
                self?.weekPosts = self?.getWeekPosts() ?? []
            }
        }
    }
    
    func fetchPostsDate(from startDate: Date, to endDate: Date, completion: @escaping([Date: [Post]]) -> Void) {
        let postRef = db.collection("posts").document(self.user.selectedUser).collection("posts")
        
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
        dateFormatter.dateFormat = "yyyy.M.d"
        return dateFormatter.string(from: date)
    }
    
    func loadImageFromFirebase(selectedUserId: String, date: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "post_images/\(self.user.selectedUser)/\(date)")
        
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
    
    func postForDate(for date: Date) -> Post {
        var post = Post()
        let hasPost = hasPosts(for: date)
        if hasPost {
            post = posts[date]!.first!
            return post
        } else {
            return post
        }
    }
    
    func getPosts(for date: Date) -> [Post]? {
        return posts[date]
    }
     
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: month),
                month: calendar.component(.month, from: month),
                day: 1)
        ) else {
            return Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.day = index
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
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
    
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
            fetchPostForMonth(self.month)
        }
    }
    
    func setClickedPost(post: Post) {
        self.clickedPost = post
    }
    
    func getDayOfWeek(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        
        return dateFormatter.string(from: date)
    }
    
    func getWeekPosts() -> [Post] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let today = Date()
        var weekPosts: [Post] = []
        
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        var weekDates: [Date] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                let startOfDay = calendar.startOfDay(for: date)
                weekDates.append(startOfDay)
            }
        }
        
        for weekDate in weekDates {
            let hasPost = hasPosts(for: weekDate)
            if hasPost {
                weekPosts.append(self.posts[weekDate]!.first!)
            }
        }
        return weekPosts
    }
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
        guard let dateString = formatter.string(for: date) else { return "Date Error" }
        return dateString
    }
}

extension MyCalendar {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    static let weekdaySymbols = Calendar.current.shortWeekdaySymbols(in: Locale(identifier: "ko_KR"))
}

extension Calendar {
    func shortWeekdaySymbols(in locale: Locale) -> [String] {
        var calendar = self
        calendar.locale = locale
        return calendar.shortWeekdaySymbols
    }
}
