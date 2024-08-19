//
//  MyFriends.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/9/24.
//

import SwiftUI

struct MyFriends: View {
    @StateObject private var viewModel: FriendsListViewModel
    @State private var selectedUser: String?
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: FriendsListViewModel(user: user))
    }
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.user.friends) { friend in
                        Button(action: {
                            selectedUser = friend.id
                        }) {
                            VStack {
                                if let imageUrl = friend.profileImageUrl, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case.empty:
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 4)
                                                )
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 4)
                                                )
                                        case .failure:
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 4)
                                                )
                                        @unknown default:
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 50)
                                                .overlay(
                                                    Circle().stroke(selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 4)
                                                )
                                        }
                                    }
                                } else {
                                    Image(systemName: "person.circle")
                                        .circularImage(size: 50)
                                        .overlay(
                                            Circle().stroke(selectedUser == friend.id ? Color.blue : Color.clear, lineWidth: 4)
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
            }
            .padding(.vertical)
        }
    }
}

