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
                    .gmarketSans(type: .medium, size: 18)
                    .padding(.vertical, 5)
                    .padding(.leading, 12)
                Spacer()
            }
            Divider()
            VStack {
                NavigationLink(destination: AccountSettings()) {
                    HStack{
                        Text("계정 관리")
                            .gmarketSans(type: .medium, size: 15)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                            .foregroundStyle(.black)
                            .padding(.vertical, 5)
                        Spacer()
                        Text(viewModel.user.email)
                            .gmarketSans(type: .medium, size: 15)
                    }
                }
                Divider()
            }
            .padding(.horizontal, 12)
            Spacer()        
        }
    }
}
