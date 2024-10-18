//
//  MyFriends.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/9/24.
//

import SwiftUI

struct MyFriends: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel

    //@EnvironmentObject var viewModel.user.selectedUser: SelectedUserId
    //@State private var selectedUser: String?

    var body: some View {
        
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    Button(action : {
                        viewModel.user.selectedUser = viewModel.user.id
                        viewModel.fetchPost()
                    }) {
                        VStack {
                            if let imageUrl = viewModel.user.profileImageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case.empty:
                                        ZStack {
                                            Circle()
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                                .blur(radius: 2)
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black)
                                                )
                                        }
                                    case .success(let image):
                                        ZStack {
                                            Circle()
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                                .blur(radius: 2)
                                            image
                                                .resizable()
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black)
                                                )
                                        }
                                    case .failure:
                                        ZStack {
                                            Circle()
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                                .blur(radius: 2)
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black)
                                                )
                                        }
                                    @unknown default:
                                        ZStack {
                                            Circle()
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                                .blur(radius: 2)
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black)
                                                )
                                        }
                                    }
                                }
                            } else {
                                ZStack {
                                    Circle()
                                        .frame(width: 54, height: 54)
                                        .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                        .blur(radius: 2)
                                    Image(systemName: "person.circle")
                                        .circularImage(size: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black)
                                        )
                                }
                            }
                            
                            Text("\(viewModel.user.nickname)")
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                    }
                    ForEach(viewModel.user.friends) { friend in
                        Button(action: {
                            viewModel.user.selectedUser = friend.id
                            viewModel.friendPost = Post()
                            viewModel.fetchFriendPost()
                        }) {
                            VStack {
                                if let imageUrl = friend.profileImageUrl, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case.empty:
                                            ZStack {
                                                Circle()
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                    .blur(radius: 2)
                                                Image(systemName: "person.circle")
                                                    .circularImage(size: 50)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(.black)
                                                    )
                                            }
                                        case .success(let image):
                                            ZStack {
                                                Circle()
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                    .blur(radius: 2)
                                                image
                                                    .resizable()
                                                    .circularImage(size: 50)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(.black)
                                                    )
                                            }
                                        case .failure:
                                            ZStack {
                                                Circle()
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                    .blur(radius: 2)
                                                Image(systemName: "person.circle")
                                                    .circularImage(size: 50)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(.black)
                                                    )
                                            }
                                        @unknown default:
                                            ZStack {
                                                Circle()
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                    .blur(radius: 2)
                                                Image(systemName: "person.circle")
                                                    .circularImage(size: 50)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(.black)
                                                    )
                                            }
                                        }
                                    }
                                } else {
                                    ZStack {
                                        Circle()
                                            .frame(width: 54, height: 54)
                                            .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                            .blur(radius: 2)
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                            .overlay(
                                                Circle()
                                                    .stroke(.black)
                                            )
                                    }
                                }
                                
                                Text(friend.nickname)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
            }
        }
    }
}

