//
//  MyPage.swift
//  Allogdallog
//
//  Created by 믕진희 on 6/17/24.
//

import SwiftUI

struct MyPage: View {
    
    @StateObject var viewModel: MyPageViewModel
    @StateObject private var profileviewModel: ProfileViewModel
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: MyPageViewModel())
        _profileviewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
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
                
                NavigationLink(destination: Setting(viewModel: profileviewModel)) { Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                        .padding(.vertical, 5)
                }
                
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
            
        }
    }
}

