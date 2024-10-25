//
//  Setting.swift
//  Allogdallog
//
//  Created by 김유진 on 10/25/24.
//

import SwiftUI


struct Setting: View {
    
    @StateObject private var viewModel: ProfileViewModel
    //@EnvironmentObject private var homeViewModel: HomeViewModel
    
    init(viewModel: ProfileViewModel) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
    
    var body: some View {
        VStack {
            HStack {
                Text("설정")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            Divider()
            
            VStack {
                
                NavigationLink(destination: AccountSettings()) {
                    
                    HStack{
                        Text("계정 관리")
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                        Spacer()
                        Text(viewModel.user.email)
                            .padding(.horizontal, 15)
                    }
                }
                Divider()
            }
            
            Spacer()
            
        }
    }
}
