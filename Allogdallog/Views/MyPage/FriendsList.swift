//
//  FriendsList.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/1/24.
//

import SwiftUI

struct FriendsList: View {
    
    @StateObject private var viewModel: FriendsListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: FriendsListViewModel(user: user))

    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .firstTextBaseline) {
                Text("친구")
                    .font(.headline)
                Text("\(viewModel.user.friends.count)명")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            
            Spacer()
            
                NavigationLink(destination: FriendSearch(user: homeViewModel.user)) {
                        Image(systemName: "person.badge.plus")
                        .resizable()
                            //.scaledToFit()
                            .frame(width: 23, height: 23)
                            .offset(x:0,y:8)
                            .foregroundStyle(.black)
                            //.clipped()
                        //.padding(.horizontal, 15)
                            //.padding(.vertical, 0)
            }
                           }
            /*VStack {
                           FriendSearch(user: viewModel.user)
                       }
                       .tabItem {
                           Label("검색", systemImage: "magnifyingglass")
                       }
                           .tag(2)
             */
            
            
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
                        .padding(.bottom, 10)
                    
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
                                    homeViewModel.user.friends.removeAll(where: { $0.id == friend.id })
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

