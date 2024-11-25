//
//  Notification.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct Notification: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var tabSelection: TabSelectionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("알림")
                    .gmarketSans(type: .medium, size: 19)
                    .padding(.vertical, 12)
                    .padding(.leading, 23)
                Spacer()
            }
            Divider()
                .padding(.bottom, 0)
            
            List(viewModel.notifications.sorted { $0.timestamp > $1.timestamp }) { notification in
                
                if notification.notificationType == "comment" {
                    
                        NavigationLink(destination: PostDetailView(viewModel: viewModel, postId: notification.postId ?? "")) {
                            Text(notification.message)
                                .gmarketSans(type: .medium, size: 15)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 10)
                                .background(Color.white)
                        }
                    } else if notification.notificationType == "friend_request" {
                        Button(action: {
                                tabSelection.selectedTab = 2
                                dismiss()
                            }) {
                            Text(notification.message)
                                .gmarketSans(type: .medium, size: 15)
                                .foregroundColor(.black)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 10)
                                .background(Color.white)
                        }
                    }
                    else if notification.notificationType == "friend_acceptance" {
                        Button(action: {
                                tabSelection.selectedTab = 2
                                dismiss()
                            }) {
                        Text(notification.message)
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundColor(.black)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            }
                    }
            }
            .listRowInsets(EdgeInsets())
            .background(Color.white)
            
            .onAppear {
                print("Current notifications count: \(viewModel.notifications.count)")
                viewModel.listenForNotifications()
            }
        }
    }
}
