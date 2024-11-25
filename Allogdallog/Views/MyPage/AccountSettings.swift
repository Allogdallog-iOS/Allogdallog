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
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            Divider()
            //임시 연결 수정 필요
            
            HStack{
                
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("로그아웃")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                }
                .navigationDestination(isPresented: $viewModel.isSignedOut) {
                    SignIn()
                }
            }
            Divider()
            
            NavigationLink(destination: DeleteAccount()) {
                
                HStack{
                    
                    Text("회원 탈퇴")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                }
            }
            Divider()
        }
        
        Spacer()
    }
}
