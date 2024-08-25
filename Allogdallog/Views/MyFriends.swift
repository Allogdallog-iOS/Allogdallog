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
                    }) {
                        VStack {
                            if let imageUrl = viewModel.user.profileImageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case.empty:
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                            .overlay(
                                                Circle().stroke(viewModel.user.selectedUser == viewModel.user.id ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .circularImage(size: 50)
                                            .overlay(
                                                Circle().stroke(viewModel.user.selectedUser == viewModel.user.id ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                    case .failure:
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                            .overlay(
                                                Circle().stroke(viewModel.user.selectedUser == viewModel.user.id ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                    @unknown default:
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                            .overlay(
                                                Circle().stroke(viewModel.user.selectedUser == viewModel.user.id ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                    }
                                }
                            } else {
                                Image(systemName: "person.circle")
                                    .circularImage(size: 50)
                                    .overlay(
                                        Circle().stroke(viewModel.user.selectedUser == viewModel.user.id ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                            }
                            
                            Text("나")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                    }
                    ForEach(viewModel.user.friends) { friend in
                        Button(action: {
                            viewModel.user.selectedUser = friend.id
                        }) {
                            VStack {
                                if let imageUrl = friend.profileImageUrl, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case.empty:
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(viewModel.user.selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 2)
                                                )
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(viewModel.user.selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 2)
                                                )
                                        case .failure:
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(viewModel.user.selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 2)
                                                )
                                        @unknown default:
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(viewModel.user.selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 2)
                                                )
                                        }
                                    }
                                } else {
                                    Image(systemName: "person.circle")
                                        .circularImage(size: 50)
                                        .overlay(
                                            Circle().stroke(viewModel.user.selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                }
                                
                                Text(friend.nickname)
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            Divider()
        }
    }
}

