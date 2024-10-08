//
//  Profile.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct Profile: View {
    
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel

    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    //var user: User
    
    var body: some View {
            
        VStack (alignment: .center) {
            HStack (alignment: .center) {
                VStack (alignment: .leading) {
                    if let imageUrl = viewModel.user.profileImageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .circularImage(size: 70)
                                .padding(.top)
                                .padding(.leading)
                        } placeholder: {
                            Image(systemName: "person.circle")
                                .circularImage(size: 70)
                                .padding(.top)
                                .padding(.leading)
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .circularImage(size: 70)
                            .padding(.top)
                            .padding(.leading)
                    }
                }
                //.foregroundColor(.gray)
                //.frame(width: 60, height: 60)
                //.font(.system(size: 50))
                // .overlay(RoundedRectangle(cornerRadius: 40)
                // .stroke(Color.gray, lineWidth: 2))
                
                VStack(alignment: .leading) {
                    
                    Text(viewModel.user.nickname)
                        .font(.system(size: 22))
                        .padding(.top)
                        .padding(.leading)
                        .bold()
                    NavigationLink(destination: ProfileEdit()){
                            Text("프로필 편집 >")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .padding(.leading)
                            Spacer()
                               }
                    
                        }
            }
            Divider()
                .padding(.top, 10)
            }
        }
    }
    

