//
//  MyFriends.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/9/24.
//

import SwiftUI

struct MyFriends: View {
    @EnvironmentObject private var viewModel: HomeViewModel
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
                                                .stroke(lineWidth: 2)
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                        }
                                    case .success(let image):
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 2)
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            image
                                                .resizable()
                                                .circularImage(size: 50)
                                        }
                                    case .failure:
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 2)
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                        }
                                    @unknown default:
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 2)
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                        }
                                    }
                                }
                            } else {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .frame(width: 54, height: 54)
                                        .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                    Image(systemName: "person.circle")
                                        .circularImage(size: 50)
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
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                Image(systemName: "person.circle")
                                                    .circularImage(size: 50)
                                            }
                                        case .success(let image):
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                image
                                                    .resizable()
                                                    .circularImage(size: 50)
                                            }
                                        case .failure:
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                Image(systemName: "person.circle")
                                                    .circularImage(size: 50)
                                            }
                                        @unknown default:
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 54, height: 54)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                Image(systemName: "person.circle")
                                                    .circularImage(size: 50)
                                            }
                                        }
                                    }
                                } else {
                                    ZStack {
                                        Circle()
                                            .stroke(lineWidth: 2)
                                            .frame(width: 54, height: 54)
                                            .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
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

