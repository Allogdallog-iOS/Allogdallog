//
//  PostDetailView.swift
//  Allogdallog
//
//  Created by 김유진 on 10/31/24.
//

import SwiftUI

struct PostDetailView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var tabSelection: TabSelectionManager
    
    var postId: String
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack {
                Text("알록달록")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                Spacer()
            }
            Divider()
            
                .onAppear {
                        viewModel.navigateToPost(by: postId)
                        print("Navigating to post with ID: \(postId)")
                    }
            Spacer()
            //tabSelection.selectedTab = 0
        }
    }
}
