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
    @StateObject private var calendarViewModel: MyCalendarViewModel
    @State private var index = 0
    @State private var path = NavigationPath()
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(user: user))
        _calendarViewModel = StateObject(wrappedValue: MyCalendarViewModel(selectedUserId: user.selectedUser))
    }
    
    var body: some View {
        TabView(selection: $index) {
            VStack {
                HStack {
                    Text("알록달록")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                    Spacer()
                }
                Divider()
                MyFriends()
                Divider()
                GeometryReader { geometry in
                    let maxHeight = geometry.size.height - 20
                    VStack {
                        if viewModel.user.selectedUser == viewModel.user.id {
                            VStack(alignment: .leading) {
                                MyDailyRecord()
                                    .frame(height: maxHeight * 0.60)
                                WeeklyRecord()
                                    .environmentObject(calendarViewModel)
                                    .frame(height: maxHeight * 0.40)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                FriendDailyRecord()
                                    .frame(height: maxHeight * 0.55)
                                FriendComments()
                                    .frame(height: maxHeight * 0.45)
                            }
                        }
                        Divider()
                    }
                }
            }
            .tabItem {
                Label("홈", systemImage: "house.fill")
            }
            .tag(1)
            /*
            VStack {
                FriendSearch(user: viewModel.user)
            }
            .tabItem {
                Label("검색", systemImage: "magnifyingglass")
            }
                .tag(2)
            */
            VStack {
                HStack {
                    Text("알록달록")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                    Spacer()
                }
                Divider()
                MyFriends()
                Divider()
                GeometryReader { geometry in
                    let maxHeight = geometry.size.height - 20
                    VStack {
                        MyCalendar(selectedUserId: viewModel.user.selectedUser)
                            .environmentObject(calendarViewModel)
                            .frame(height: maxHeight)
                        Divider()
                    }
                }
            }
            .tabItem {
                Label("캘린더", systemImage: "calendar")
            }
            .tag(2)
            VStack {
                MyPage()
                Profile(user:viewModel.user)
                FriendsList(user: viewModel.user)
                Spacer()
            }
            .tabItem {
                Label("마이페이지", systemImage: "person.fill")
            }
            .tag(3)
            
        }
        .environmentObject(viewModel)
        .navigationBarBackButtonHidden()
    }
}
