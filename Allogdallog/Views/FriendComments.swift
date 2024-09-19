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
                    .font(.callout)
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
                                        image
                                            .resizable()
                                            .circularImage(size: 45)
                                    } placeholder: {
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 45)
                                    }
                                } else {
                                    Image(systemName: "person.circle")
                                        .circularImage(size: 45)
                                }
                                VStack {
                                    HStack {
                                        Text("\(comment.fromUserNick)")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(comment.comment)")
                                            .font(.caption2)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .frame(height: 120)
            VStack {
                Divider()
                HStack {
                    if let url = URL(string: viewModel.user.profileImageUrl ?? "") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .circularImage(size: 45)
                        } placeholder: {
                            Image(systemName: "person.circle")
                                .circularImage(size: 45)
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .circularImage(size: 45)
                    }
                    HStack {
                        TextField("반응을 남겨주세요!", text: $viewModel.myComment)
                            .padding()
                            .textFieldStyle(PlainTextFieldStyle())
                        Button(action: {
                            viewModel.uploadComment()
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 5)
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
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    FriendComments()
}
