//
//  Profile.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct Profile: View {
    
    @EnvironmentObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
            
        VStack (alignment: .center) {
            HStack (alignment: .center) {
                VStack (alignment: .leading) {
                    if let imageUrl = homeViewModel.user.profileImageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            ZStack {
                                Circle()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color.clear)
                                
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle()).mask(Circle().frame(width: 70, height: 70))
                                    .overlay(
                                        Circle()
                                            .stroke(.black)
                                            .frame(width: 70, height: 70)
                                    )
                            }.frame(width: 70, height: 70)
                        } placeholder: {
                            ZStack {
                                Circle()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color.clear)
                                
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundStyle(Color.myLightGray)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle()).mask(Circle().frame(width: 70, height: 70))
                                    .overlay(
                                        Circle()
                                            .stroke(.black)
                                            .frame(width: 70, height: 70)
                                    )
                            }.frame(width: 70, height: 70)
                        }
                    } else {
                        ZStack {

                            Circle()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.clear)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(Color.myLightGray)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle()).mask(Circle().frame(width: 70, height: 70))
                                .overlay(
                                    Circle()
                                        .stroke(.black)
                                        .frame(width: 70, height: 70)
                                )
                                .padding(.top)
                        }.frame(width: 80, height: 80) 
                            .padding(.top)
                    }
                }

                
                VStack(alignment: .leading) {
                    Text(homeViewModel.user.nickname)
                        .gmarketSans(type: .medium, size: 18)
                        .padding(.leading)
                        .padding(.bottom, 3)
                    NavigationLink(destination: ProfileEdit(user: viewModel.user)){
                        Text("프로필 편집 >")
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundStyle(.gray)
                            .padding(.leading)
                        Spacer()
                    }
                    
                }
            }
            .padding(.horizontal, 2)
            Divider()
            .padding(.top, 10)
        }.padding(.top, 17)
    }
}
    

