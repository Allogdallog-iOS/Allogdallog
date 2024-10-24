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
            
            HStack {
                Text("친구 추가")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                
                Spacer()
            }
            
            TextField("닉네임을 입력해보세요!", text: $viewModel.searchText, onCommit: {
                viewModel.searchFriends()
            })
            .padding(.leading, 30)  // 아이콘과 텍스트 사이 여백
            .customTextFieldStyle(height: 40)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)  // 왼쪽 정렬
                        .padding(.leading, 8)
                }
            )
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            .padding()

            
            VStack {
                    Text("친구의 닉네임을 검색하여")
                        .fontWeight(.ultraLight)
                        //.padding(.horizontal, 15)
                        //.padding(.vertical, 5)
                        .frame(maxWidth: .infinity,
                               //maxHeight: .infinity,
                               alignment: .center)
                        
                    Text("알록달록 친구로 추가해보세요.")
                        .fontWeight(.ultraLight)
                        //.padding(.horizontal, 15)
                        //.padding(.vertical, 5)
                        .frame(maxWidth: .infinity,
                               //maxHeight: .infinity,
                               alignment: .center)
                        
                }
            //Spacer()
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchResults, id: \.id) { user in
                        HStack {
                            if let imageUrl = user.profileImageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(Color(UIColor.systemGray4))
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
                                    case .failure:
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(Color(UIColor.systemGray4))
                                            .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
                                    @unknown default:
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(Color(UIColor.systemGray4))
                                            .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
                                    }
                                }
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color(UIColor.systemGray4))
                                    .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50))
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
