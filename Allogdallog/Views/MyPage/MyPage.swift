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
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 8)
                
                Spacer()
                
                NavigationLink(destination: Setting(viewModel: profileviewModel)) { Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                        .padding(.vertical, 5)
                }
                
                ZStack {
                    NavigationLink(destination: Notification(viewModel: homeviewModel)
                        .environmentObject(tabSelection)
                        .onAppear {
                        markNotificationsAsRead()
                    }) { Image(systemName: "bell")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
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
            
        } .onAppear {
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

