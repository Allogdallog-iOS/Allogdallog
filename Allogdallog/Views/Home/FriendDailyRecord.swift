//
//  FriendHome.swift
//  Allogdallog
//
//  Created by 믕진희 on 9/4/24.
//

import SwiftUI

struct FriendDailyRecord: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("\(viewModel.getDate())")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            ZStack {
                if viewModel.friendPostUploaded {
                    HStack {
                        if let image = viewModel.friendImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 165, height: 215)
                                .border(.myGray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Spacer()
                        VStack {
                            HStack {
                                Text("\(viewModel.friendPost.todayColor)")
                                    .font(.callout)
                                Spacer()
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(viewModel.friendSelectedColor)
                                    .blur(radius: 2.0)
                            }
                            .padding()
                            .frame(width: 150, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.myGray)
                            )
                            Spacer()
                            Text("\(viewModel.friendPost.todayText)")
                                .padding()
                                .frame(width: 150, height: 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.myGray)
                                )
                        }
                    }
                    .frame(height: 215)
                } else {
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.myGray)
                            .frame(width: 165, height: 215)
                        Spacer()
                        VStack {
                            HStack {
                                Text("#000000")
                                    .font(.callout)
                                Spacer()
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.black)
                                    .blur(radius: 2.5)
                            }
                            .padding()
                            .frame(width: 150, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.myGray)
                            )
                            Spacer()
                            Text("  ")
                                .padding()
                                .frame(width: 150, height: 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.myGray)
                                )
                        }
                    }
                    .frame(height: 215)
                    Rectangle()
                        .frame(height: 215)
                        .foregroundStyle(Color.black)
                        .opacity(0.2)
                    Text("아직 게시글을 작성하지 않았습니다.")
                        .foregroundStyle(.white)
                }
                
            }
        }
        .padding(.horizontal, 20)
    }
}
