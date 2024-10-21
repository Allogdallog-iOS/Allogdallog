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
    @State private var isLoading = true  // 로딩 상태 변수
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(user: user))
        _calendarViewModel = StateObject(wrappedValue: MyCalendarViewModel(selectedUserId: user.selectedUser))
    }
    
    var body: some View {
        ZStack {
                   if isLoading {
                       // 로딩 중일 때는 LoadingView를 표시
                       LoadingView()
                   } else {
                       // 로딩이 끝났을 때 홈뷰 내용 표시
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
                Logout()
                DeleteAccount()
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
        .onAppear {
                    // 데이터 로딩을 시뮬레이션하거나 실제 네트워크 요청을 이곳에 추가합니다.
                    loadData()
                }
            }
            
            // 로딩 데이터를 처리하는 함수
            func loadData() {
                // 로딩 작업 시작 (네트워크 작업, 데이터 처리 등)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    // 로딩이 끝나면 isLoading을 false로 설정하여 로딩 화면을 숨김
                    isLoading = false
                }
            }
        }





