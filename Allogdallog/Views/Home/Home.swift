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
                        HStack {
                            Image("image/logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 72, height: 27)
                                .clipped()
                                .padding(.horizontal, 10)
                            Spacer()

                        }
                        .frame(height: 55)
                        Divider()
                            .padding(.bottom, 8)
                        ScrollView {
                            VStack {
                                MyFriends()
                                    .frame(height: 90)
                                Divider()
                                if viewModel.user.selectedUser == viewModel.user.id {
                                    VStack(alignment: .leading) {
                                        MyDailyRecord()
                                            .frame(height: 320)
                                            .padding(.bottom, 15)
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
                                                .frame(height: 270)
                                            FriendComments()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .refreshable {
                            viewModel.refreshData()
                            loadData()
                        }
                    }
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(0)
                
                    VStack(spacing: 0) {
                        VStack {
                            HStack {
                                Text("캘린더")
                                    .gmarketSans(type: .medium, size: 19)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 5)
                                Spacer()
                            }
                        }.frame(height: 55)
                        Divider()
                            .padding(.bottom, 8)
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
                            loadData()
                        }
                    }
                    .tabItem {
                        Label("캘린더", systemImage: "calendar")
                    }
                    .tag(1)
                    VStack(spacing: 0){
                        MyPage(user: viewModel.user)
                        
                        ScrollView {
                            Profile().environmentObject(profileViewModel)
                            FriendsList(user: viewModel.user)
                                .frame(height: 450)
                            Spacer()
                        }.padding(.horizontal, 12)
                        .refreshable {
                            viewModel.refreshData()
                            loadData()
                        }
                        
                    }.environmentObject(viewModel)
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





