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
                                        ZStack {
                                            // 원형 배경을 만들기
                                            Circle()
                                                .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                .foregroundColor(Color.clear) // 투명한 배경
                                            
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                        }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                    } placeholder: {
                                        ZStack {
                                            // 원형 배경을 만들기
                                            Circle()
                                                .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                .foregroundColor(Color.clear) // 투명한 배경
                                            
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .foregroundStyle(Color.myLightGray)
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                        }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                    }
                                } else {
                                    ZStack {
                                        // 원형 배경을 만들기
                                        Circle()
                                            .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                            .foregroundColor(Color.clear) // 투명한 배경
                                        
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .foregroundStyle(Color.myLightGray)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
                                    }.frame(width: 50, height: 50)
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
                                        ZStack {
                                            // 원형 배경을 만들기
                                            Circle()
                                                .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                .foregroundColor(Color.clear) // 투명한 배경
                                            
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                        }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                    } placeholder: {
                                        ZStack {
                                            // 원형 배경을 만들기
                                            Circle()
                                                .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                .foregroundColor(Color.clear) // 투명한 배경
                                            
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .foregroundStyle(Color.myLightGray)
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                        }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                    }
                                } else {
                                    ZStack {
                                        // 원형 배경을 만들기
                                        Circle()
                                            .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                            .foregroundColor(Color.clear) // 투명한 배경
                                        
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .foregroundStyle(Color.myLightGray)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                        
                                    }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
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

