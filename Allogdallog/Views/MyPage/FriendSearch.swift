//
//  FriendRequest.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/8/24.
//

import SwiftUI

struct FriendSearch: View {
    
    @StateObject private var viewModel: FriendSearchViewModel

    init(user: User) {
        _viewModel = StateObject(wrappedValue: FriendSearchViewModel(user: user))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("닉네임을 검색해보세요!", text: $viewModel.searchText, onCommit: {
                viewModel.searchFriends()
            })
            .customTextFieldStyle(height: 40)
            .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchResults, id: \.id) { user in
                        HStack {
                            if let imageUrl = user.profileImageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .circularImage(size: 50)
                                    case .failure:
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                    @unknown default:
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                    }
                                }
                            } else {
                                Image(systemName: "person.circle")
                                    .circularImage(size: 50)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(user.nickname)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            if viewModel.isFriend(userId: user.id) {
                                Button(action: {
                                    viewModel.unfriend(friend: Friend(id: user.id, nickname: user.nickname, profileImageUrl: user.profileImageUrl ?? "", postUploaded: user.postUploaded))
                                }) {
                                    Text("친구 끊기")
                                        .font(.caption)
                                        .padding()
                                        .frame(height: 30)
                                        .background(.myLightGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            } else if viewModel.hasSentRequest(toUser: user) {
                                Text("요청됨")
                                    .font(.caption)
                                    .padding()
                                    .frame(height: 30)
                                    .background(.myLightGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                Button(action: {
                                    viewModel.sendFriendRequest(toUser: user)
                                }) {
                                    Text("친구 신청")
                                        .font(.caption)
                                        .padding()
                                        .frame(height: 30)
                                        .background(.black)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}