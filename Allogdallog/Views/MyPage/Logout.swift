//
//  Logout.swift
//  Allogdallog
//
//  Created by 김유진 on 10/8/24.
//

import SwiftUI

struct Logout: View {
    
    @StateObject var viewModel: MyPageViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MyPageViewModel())
    }
    
    var body: some View {
        VStack {
            
            Divider()
            Button(action: {
                viewModel.signOut()
            }) {
                Text("로그아웃")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
            }
            .navigationDestination(isPresented: $viewModel.isSignedOut) {
                SignIn()
            }
        }
    }
}

#Preview {
    Logout()
}
