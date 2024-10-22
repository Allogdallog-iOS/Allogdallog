//
//  MyPage.swift
//  Allogdallog
//
//  Created by 믕진희 on 6/17/24.
//

import SwiftUI

struct MyPage: View {
    
    @StateObject var viewModel: MyPageViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MyPageViewModel())
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("마이페이지")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                
                Spacer()
                
                NavigationLink(destination: Notification()) { Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                }
                
            }
            Divider()
            Button(action: {
                viewModel.signOut()
            }) {
                Text("로그아웃")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .navigationDestination(isPresented: $viewModel.isSignedOut) {
                SignIn()
            } 
        }
    }
}
