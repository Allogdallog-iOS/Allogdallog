//
//  Comment.swift
//  Allogdallog
//
//  Created by 믕진희 on 9/12/24.
//

import SwiftUI

struct FriendComments: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("반응 \(viewModel.friendPost.todayComments.count)개")
                    .gmarketSans(type: .medium, size: 13)
                Spacer()
            }
            Divider()
            ScrollView {
                VStack {
                    if !viewModel.friendPost.todayComments.isEmpty {
                        ForEach(viewModel.friendPost.todayComments) { comment in
                            HStack {
                                if let url = URL(string: comment.fromUserImgUrl) {
                                    AsyncImage(url: url) { image in
                                        ZStack {
                                            image
                                                .resizable()
                                                .circularImage(size: 40)
                                            Circle()
                                                .stroke(.black)
                                                .frame(width: 40, height: 40)
                                        }
                                    } placeholder: {
                                        ZStack {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .circularImage(size: 40)
                                            Circle()
                                                .stroke(.black)
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .circularImage(size: 40)
                                    Circle()
                                        .stroke(.black)
                                        .frame(width: 40, height: 40)
                                }
                                VStack {
                                    HStack {
                                        Text("\(comment.fromUserNick)")
                                            .gmarketSans(type: .bold, size: 12)
                                        Spacer()
                                    }
                                    .padding(.bottom, 3)
                                    HStack {
                                        Text("\(comment.comment)")
                                            .gmarketSans(type: .medium, size: 12)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                        }
                    }
                }
               
            }
            .frame(height: 130)
            Spacer()
            Divider()
            HStack {
                if let url = URL(string: viewModel.user.profileImageUrl ?? "") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .circularImage(size: 45)
                            .overlay(
                                Circle()
                                    .stroke(.black)
                                    .frame(width: 45, height: 45)
                            )
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .circularImage(size: 45)
                            .overlay(
                                Circle()
                                    .stroke(.black)
                                    .frame(width: 45, height: 45)
                            )
                            .foregroundStyle(.myGray)
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .circularImage(size: 45)
                        .foregroundStyle(.myGray)
                }
                HStack {
                    TextField("반응을 남겨주세요!", text: $viewModel.myComment)
                        .padding()
                        .textFieldStyle(PlainTextFieldStyle())
                        .gmarketSans(type: .medium, size: 15)
                    Button(action: {
                        if viewModel.selectedDate.isEmpty {
                            viewModel.uploadComment(date: viewModel.getDateString(date: Date()))
                        } else {
                            viewModel.uploadComment(date: viewModel.selectedDate)
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.horizontal, 10)
                            .foregroundStyle(.myGray)
                    }
                    .disabled(!viewModel.friendPostUploaded)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .overlay(RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.myLightGray)
                )
            }
            .background(Color.white)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    FriendComments()
}
