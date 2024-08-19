//
//  FriendsList.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/1/24.
//

import SwiftUI

struct FriendsList: View {
    
    @StateObject private var viewModel: FriendsListViewModel
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: FriendsListViewModel(user: user))

    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text("친구")
                    .font(.headline)
                Text("\(viewModel.user.friends.count)명")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    if !viewModel.user.receivedRequests.isEmpty {
                        ForEach(viewModel.user.receivedRequests) { request in
                            HStack {
                                if let url = URL(string: request.fromUserImgUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .circularImage(size: 50)
                                    } placeholder: {
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                    }
                                } else {
                                    Image(systemName: "person.circle")
                                        .circularImage(size: 50)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("친구 신청")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    Text("\(request.fromUserNick)")
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.rejectFriendRequest(request: request)
                                }) {
                                    Text("거절")
                                        .font(.caption)
                                        .padding()
                                        .frame(height: 30)
                                        .background(.myLightGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                Button(action: {
                                    viewModel.acceptFriendRequest(request: request)
                                }) {
                                    Text("수락")
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
                    Divider()
                    
                    if !viewModel.user.friends.isEmpty {
                        ForEach(viewModel.user.friends) { friend in
                            HStack{
                                if let imageUrl = friend.profileImageUrl, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .circularImage(size: 50)
                                    } placeholder: {
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 50)
                                    }
                                } else {
                                    Image(systemName: "person.circle")
                                        .circularImage(size: 50)
                                }
                                
                                Text(friend.nickname)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.unfriend(friend: friend)
                                }) {
                                    Text("친구 끊기")
                                        .font(.caption)
                                        .padding()
                                        .frame(height: 30)
                                        .background(.myLightGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
