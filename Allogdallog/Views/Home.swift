//
//  Home.swift
//  Allogdallog
//
//  Created by 믕진희 on 6/17/24.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    
    @StateObject private var userViewModel = UserViewModel()
    @State private var index = 0
    
    var body: some View {
        VStack {
            MyFriends()
            TabView(selection: $index) {
                VStack {
                    if let user = userViewModel.user {
                        FriendSearch(user: user)
                    } else {
                        Text("데이터를 불러오는 중입니다.")
                            .onAppear {
                                if let userId = Auth.auth().currentUser?.uid {
                                    userViewModel.fetchUser(userId: userId)
                                } else {
                                    print("User is not logged in")
                                }
                            }
                    }
                }
                        
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(1)
                Calendar()
                    .tabItem {
                        Label("캘린더", systemImage: "calendar")
                    }
                    .tag(2)
            }
        }
    }
}

#Preview {
    Home()
}
