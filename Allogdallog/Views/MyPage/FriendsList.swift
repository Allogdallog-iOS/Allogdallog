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
                    .gmarketSans(type: .medium, size: 15)
                Text("\(viewModel.user.friends.count)명")
                    .gmarketSans(type: .medium, size: 13)
                    .foregroundStyle(.gray)
            
            Spacer()
            
                NavigationLink(destination: FriendSearch(user: homeViewModel.user)) {
                        Image(systemName: "person.badge.plus")
                        .resizable()
                            .frame(width: 20, height: 20)
                            .offset(x:0, y:8)
                            .foregroundStyle(.black)
                }
            }
            
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
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
                                                .overlay(
                                                    Circle()
                                                        .stroke(.black)
                                                        .frame(width: 50, height: 50)
                                                )
                                            // 50x50 영역만 보여주도록 마스크 적용
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
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
                                                .overlay(
                                                    Circle()
                                                        .stroke(.black)
                                                        .frame(width: 50, height: 50)
                                                )
                                            // 50x50 영역만 보여주도록 마스크 적용
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
                                            .overlay(
                                                Circle()
                                                    .stroke(.black)
                                                    .frame(width: 50, height: 50)
                                            )
                                    }.frame(width: 50, height: 50)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("친구 신청")
                                        .gmarketSans(type: .medium, size: 12)
                                        .foregroundStyle(.gray)
                                    Text("\(request.fromUserNick)")
                                        .gmarketSans(type: .medium, size: 12)
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.rejectFriendRequest(request: request)
                                }) {
                                    Text("거절")
                                        .gmarketSans(type: .medium, size: 12)
                                        .padding()
                                        .frame(height: 30)
                                        .background(.myLightGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                Button(action: {
                                    viewModel.acceptFriendRequest(request: request)
                                }) {
                                    Text("수락")
                                        .gmarketSans(type: .medium, size: 12)
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
                        .padding(.vertical, 10)
                    
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
                                                .overlay(
                                                    Circle()
                                                        .stroke(.black)
                                                        .frame(width: 50, height: 50)
                                                )
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
                                                .overlay(
                                                    Circle()
                                                        .stroke(.black)
                                                        .frame(width: 50, height: 50)
                                                )
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
                                            .overlay(
                                                Circle()
                                                    .stroke(.black)
                                                    .frame(width: 50, height: 50)
                                            )
                                        
                                    }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                }
                                
                                Text(friend.nickname)
                                    .gmarketSans(type: .medium, size: 13)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.unfriend(friend: friend)
                                    homeViewModel.user.friends.removeAll(where: { $0.id == friend.id })
                                }) {
                                    Text("친구 끊기")
                                        .gmarketSans(type: .medium, size: 12)
                                        .padding()
                                        .frame(height: 30)
                                        .background(.myLightGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            .padding(.bottom, 5)
                            .padding(.horizontal, 2)
                        }
                    }
                }
            }
        }
    }
}

