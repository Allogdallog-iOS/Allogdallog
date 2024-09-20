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
