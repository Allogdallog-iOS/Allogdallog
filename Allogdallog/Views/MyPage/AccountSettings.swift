//
//  AccountSettings.swift
//  Allogdallog
//
//  Created by 김유진 on 10/25/24.
//

import SwiftUI

struct AccountSettings: View {
    
    @StateObject var viewModel: MyPageViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MyPageViewModel())
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("계정 관리")
                    .gmarketSans(type: .medium, size: 18)
                    .padding(.vertical, 5)
            }
            Divider()
            
            HStack{
                
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("로그아웃")
                        .gmarketSans(type: .medium, size: 16)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                }
                .navigationDestination(isPresented: $viewModel.isSignedOut) {
                    SignIn()
                }
            }
            Divider()
            
                NavigationLink(destination: DeleteAccount()) {
                    HStack{
                        Text("회원 탈퇴")
                            .gmarketSans(type: .medium, size: 16)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                    }
                }
                Divider()
            }
            .padding(.horizontal, 12)
        
        Spacer()
    }
}
