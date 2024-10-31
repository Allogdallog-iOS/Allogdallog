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
    @StateObject private var tabSelection = TabSelectionManager()
    @StateObject private var profileViewModel : ProfileViewModel
    @State private var path = NavigationPath()
    @State private var isLoading = true
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(user: user))
        _calendarViewModel = StateObject(wrappedValue: MyCalendarViewModel(user: user))
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                    LoadingView()
            } else {
                // 로딩이 끝났을 때 홈뷰 내용 표시
                TabView(selection: $tabSelection.selectedTab) {
                    ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Image("image/logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 42)
                                .clipped()
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
                                            .frame(height: 340)
                                            //.frame(height: maxHeight * 0.65)
                                        Divider()
                                            .padding(.vertical, 5)
                                        Button(action: {
                                            tabSelection.selectedTab = 1
                                        }) {
                                            WeeklyRecord()
                                                .environmentObject(calendarViewModel)
                                                .frame(height: maxHeight * 0.35)
                                        }
                                    }
                                } else {
                                    ScrollView {
                                        VStack(alignment: .leading) {
                                            FriendDailyRecord()
                                                .frame(height: 300)
                                            //.frame(height: maxHeight * 0.55)
                                            FriendComments()
                                                .frame(height: 230)
                                            //.frame(height: maxHeight * 0.45)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 560)
                    }
                    .padding(.horizontal, 15)
                }
                .refreshable {
                    viewModel.refreshData()
                    loadData() // 데이터 새로 고침
                }
                    .tabItem {
                        Label("홈", systemImage: "house.fill")
                    }
                    .tag(0)
                    
                    ScrollView {
                        VStack(spacing: 0){
                            HStack {
                                Image("image/logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 42)
                                    .clipped()
                                    
                                Spacer()
                            }
                            Divider()
                            MyFriends()
                            Divider()
                            GeometryReader { geometry in
                                let maxHeight = geometry.size.height - 20
                                VStack {
                                    MyCalendar(user: viewModel.user)
                                        .environmentObject(calendarViewModel)
                                        .frame(height: maxHeight)
                                }
                            }.padding(.vertical, 15)
                            .frame(height: 550)
                        }
                        .padding(.horizontal, 15)
                    }
                    .refreshable {
                        viewModel.refreshData()
                        loadData() // 데이터 새로 고침
                    }
                        
                    .tabItem {
                        Label("캘린더", systemImage: "calendar")
                    }
                    .tag(1)
                    
                    ScrollView {
                        VStack(spacing: 0){
                            MyPage(user: viewModel.user)
                            Profile().environmentObject(profileViewModel)
                            FriendsList(user: viewModel.user)
                            Logout()
                            Spacer()
                        }.environmentObject(viewModel)
                            //.padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .frame(height: 735)
                    }
                    .refreshable {
                        viewModel.refreshData()
                        loadData() // 데이터 새로 고침
                    }
                        .tabItem {
                            Label("마이페이지", systemImage: "person.fill")
                        }
                        .tag(2)
                    
                }
                .tint(.black)
                .environmentObject(viewModel)
                .environmentObject(tabSelection)
                .navigationBarBackButtonHidden()
            }
        }.onAppear {
            loadData()
        }
    }
            
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
            print("Loading complete, isLoading set to false")
            
        }
    }
}





