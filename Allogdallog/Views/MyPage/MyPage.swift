//
//  MyPage.swift
//  Allogdallog
//
//  Created by 믕진희 on 6/17/24.
//

import SwiftUI

struct MyPage: View {
    
    @ObservedObject var viewModel: MyPageViewModel
    @StateObject private var profileviewModel: ProfileViewModel
    @StateObject var homeviewModel: HomeViewModel
    @StateObject private var tabSelection = TabSelectionManager()
    //@State private var hasNewNotification: Bool = false
    
    init(user: User) {
        _viewModel = ObservedObject(wrappedValue: MyPageViewModel())
        _profileviewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
        _homeviewModel = StateObject(wrappedValue: HomeViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("마이페이지")
<<<<<<< HEAD
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 17)
                    //.padding(.vertical, 8)
                
=======
                    .gmarketSans(type: .medium, size: 18)
                    .padding(.horizontal, 15)
>>>>>>> 040c3f11d06c18b194bb15292e552c1a577c3d67
                Spacer()
                NavigationLink(destination: Setting(viewModel: profileviewModel)) { Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
<<<<<<< HEAD
                        //.padding(.vertical, 5)
=======
>>>>>>> 040c3f11d06c18b194bb15292e552c1a577c3d67
                }
                ZStack {
                    NavigationLink(destination: Notification(viewModel: homeviewModel)
                        .environmentObject(tabSelection)
                        .onAppear {
                        markNotificationsAsRead()
                    }) { Image(systemName: "bell")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 15)
<<<<<<< HEAD
                            //.padding(.vertical, 5)
=======
>>>>>>> 040c3f11d06c18b194bb15292e552c1a577c3d67
                    }
                    if homeviewModel.notifications.contains(where: { !$0.isRead }) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 12, y: -12) // 아이콘의 오른쪽 위에 위치시킴
                    }
                }
                
            }
            Divider()
        }
        .frame(height: 60)
        .onAppear {
            print("MyPage appeared, checking for new notifications...")
            homeviewModel.listenForNotifications()
        }
    }
    private func markNotificationsAsRead() {
            homeviewModel.notifications.forEach { notification in
                if !notification.isRead { 
                    homeviewModel.updateNotificationAsRead(notification: notification)
                }
            }
    }
}

