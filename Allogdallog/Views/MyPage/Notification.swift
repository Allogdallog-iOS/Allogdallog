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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("알림")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            Divider()
                .padding(.bottom, 0)
            
            List(viewModel.notifications.sorted { $0.timestamp > $1.timestamp }) { notification in
                
            NavigationLink(destination: PostDetailView(viewModel: viewModel, postId: notification.postId ?? "")) {
                    Text(notification.message)
                        .font(.body)
                        .padding(25)
                        .background(Color.white)
                        /*.onTapGesture {
                            viewModel.markNotificationAsRead(notification: notification)
                        }*/
                }
                .listRowInsets(EdgeInsets())
            }//.listStyle(PlainListStyle())
            .background(Color.white)
            
            .onAppear {
                print("Current notifications count: \(viewModel.notifications.count)")
                viewModel.listenForNotifications()
            }
        }
    }
}
