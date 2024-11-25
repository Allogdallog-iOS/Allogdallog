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
                    VStack(spacing: 0) {
<<<<<<< HEAD
                        HStack {
                            Image("image/logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 72, height: 27)
                                .clipped()
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                            Spacer()
=======
                        VStack {
                            HStack {
                                Image("image/icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 35)
                                    .padding(.leading, 12)
                                Spacer()
                            }
                            Divider()
>>>>>>> 040c3f11d06c18b194bb15292e552c1a577c3d67
                        }
                        .frame(height: 60)
                        ScrollView {
                            VStack {
                                MyFriends()
                                    .frame(height: 90)
                                    .padding(.bottom, 10)
                                Divider()
                                    .padding(.bottom, 10)
                                if viewModel.user.selectedUser == viewModel.user.id {
                                    VStack(alignment: .leading) {
                                        MyDailyRecord()
<<<<<<< HEAD
                                            .frame(height: 330)
=======
                                            .frame(height: 320)
>>>>>>> 040c3f11d06c18b194bb15292e552c1a577c3d67
                                        Divider()
                                        Button(action: {
                                            tabSelection.selectedTab = 1
                                        }) {
                                            WeeklyRecord()
                                                .frame(height: 150)
                                                .environmentObject(calendarViewModel)
                                        }
                                    }
                                } else {
                                    ScrollView {
                                        VStack(alignment: .leading) {
                                            FriendDailyRecord()
                                                .frame(height: 250)
                                            FriendComments()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .refreshable { // ScrollView에서 아래로 끌어내리면 호출되는 부분
                            viewModel.refreshData()
                            loadData() // 데이터 새로 고침
                            
                        }
                    }
<<<<<<< HEAD
                }
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(0)
                VStack(spacing: 0) {
                    HStack {
                        /* Image("image/logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 15)
                            .clipped()
                            .padding(.leading, 15)
                            .padding(.vertical, 12)*/
                        Text("캘린더")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 10)
                        Spacer()
=======
                    .tabItem {
                        Label("홈", systemImage: "house.fill")
>>>>>>> 040c3f11d06c18b194bb15292e552c1a577c3d67
                    }
                    .tag(0)
                    VStack(spacing: 0) {
                        VStack {
                            HStack {
                                Text("캘린더")
                                    .gmarketSans(type: .medium, size: 18)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                            Divider()
                        }
                        .frame(height: 60)
                        ScrollView {
                            MyFriends()
                                .frame(height: 90)
                            Divider()
                                .padding(.bottom, 10)
                            MyCalendar(user: viewModel.user)
                                .environmentObject(calendarViewModel)
                        }
                        .padding(.horizontal, 12)
                        .refreshable {
                            viewModel.refreshData()
                            loadData() // 데이터 새로 고침
                        }
                    }
                    .tabItem {
                        Label("캘린더", systemImage: "calendar")
                    }
                    .tag(1)
                    VStack(spacing: 0){
                        MyPage(user: viewModel.user)
<<<<<<< HEAD
                        Profile().environmentObject(profileViewModel)
                        FriendsList(user: viewModel.user)
                        //Logout()
                        Spacer()
=======
                        ScrollView {
                            Profile().environmentObject(profileViewModel)
                            FriendsList(user: viewModel.user)
                                .frame(height: 450)
                            Spacer()
                            Logout()
                        }
                        .refreshable {
                            viewModel.refreshData()
                            loadData() // 데이터 새로 고침
                        }
                        .padding(.horizontal, 12)
>>>>>>> 040c3f11d06c18b194bb15292e552c1a577c3d67
                    }.environmentObject(viewModel)
                    .padding(.vertical, 12)
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





