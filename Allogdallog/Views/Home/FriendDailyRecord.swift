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
            HStack {
                Spacer()
                if viewModel.selectedDate.isEmpty {
                    Text("\(viewModel.getTodayDateString())")
                        .instrumentSansItalic(type:.bold, size: 25)
                } else {
                    Text(viewModel.selectedDate)
                        .instrumentSansItalic(type:.bold, size: 25)
                }
                Spacer()
            }
            .padding()
            if viewModel.friendPost.id.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .frame(height: 200)
                    Text("아직 게시글을 작성하지 않았어요.")
                }
                .padding(.horizontal, 5)
            } else {
                HStack {
                    VStack {
                        Spacer()
                        Text("색상")
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundStyle(.myDarkGray)
                        Spacer()
                        VStack(alignment: .center) {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color(hex: viewModel.friendPost.todayColor))
                        }
                        .frame(height: 180)
                    }
                    .padding(.leading, 10)
                    Spacer()
                    VStack {
                        Spacer()
                        Text("사진")
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundStyle(.myDarkGray)
                        Spacer()
                        if let url = URL(string: viewModel.friendPost.todayImgUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 140, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black)
                                    )
                            } placeholder: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black)
                                        .frame(width: 140, height: 180)
                                    Image(systemName: "photo.badge.plus.fill")
                                        .foregroundStyle(.black)
                                }
                            }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black)
                                    .frame(width: 140, height: 180)
                                Image(systemName: "photo.badge.plus.fill")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        Text("이모티콘")
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundStyle(.myDarkGray)
                        Spacer()
                        VStack(alignment: .center) {
                            Text("\(viewModel.friendPost.todayText)")
                                .frame(height: 80)
                                .font(.system(size: 50))
                        }
                        .frame(height: 180)
                    }
                    .padding(.trailing, 10)
                }
            }
            Spacer()
        }
    }
}
