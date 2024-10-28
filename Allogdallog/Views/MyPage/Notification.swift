//
//  Notification.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct Notification: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("알림")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            Divider()
            
            List(viewModel.notifications) { notification in
                Text(notification.message)
                            .font(.body)
                            .padding()
            }.onAppear {
                print("Current notifications count: \(viewModel.notifications.count)")
                viewModel.listenForNotifications()
            }
            
            Spacer()
        }
    }
}
