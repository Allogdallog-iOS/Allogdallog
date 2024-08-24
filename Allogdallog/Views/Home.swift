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
    @StateObject private var viewModel: HomeViewModel
    @State private var index = 0
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(user: user))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            MyFriends()
            TabView(selection: $index) {
                VStack {
                    if viewModel.user.selectedUser == viewModel.user.id {
                        MyHome()
                    } else {
                        FriendHome()
                    }
                }
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(1)
                VStack {
                    if let user = userViewModel.user {
                        FriendsList(user: user)
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
                        Label("캘린더", systemImage: "calendar")
                    }
                    .tag(2)
            }
        }
        .environmentObject(viewModel)
    }
}

struct MyHome: View {
    var body: some View {
        Text("My")
    }
}

struct FriendHome: View {
    var body: some View {
        Text("Friend")
    }
}
