//
//  Home.swift
//  Allogdallog
//
//  Created by 믕진희 on 6/17/24.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    
    //@StateObject private var userViewModel = UserViewModel()
    @StateObject private var viewModel: HomeViewModel
    @State private var index = 0
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(user: user))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            MyFriends()
            TabView(selection: $index) {
                VStack(alignment: .leading) {
                    if viewModel.user.selectedUser == viewModel.user.id {
                        MyDailyRecord()
                    } else {
                        FriendHome()
                    }
                }
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(1)
                VStack {
                    FriendsList(user: viewModel.user)
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
