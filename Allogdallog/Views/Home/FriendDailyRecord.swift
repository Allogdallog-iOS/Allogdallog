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
                Text("\(viewModel.getDate())")
                    .instrumentSansItalic(type:.bold, size: 25)
                Spacer()
            }
            Spacer()
            ZStack {
                if viewModel.friendPostUploaded {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("color")
                                .instrumentSerif(size: 24)
                            Spacer()
                            VStack(alignment: .center) {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(viewModel.friendSelectedColor)
                                    .blur(radius: 5.0)
                            }
                            .frame(height: 180)
                        }
                        Spacer()
                        VStack {
                            Spacer()
                            Text("picture")
                                .instrumentSerif(size: 24)
                            Spacer()
                            if let image = viewModel.friendImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 140, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black)
                                    )
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
                            Text("emoji")
                                .instrumentSerif(size: 24)
                            Spacer()
                            VStack(alignment: .center) {
                                Text("\(viewModel.friendPost.todayText)")
                                    .frame(height: 80)
                                    .font(.system(size: 50))
                            }
                            .frame(height: 180)
                        }
                        Spacer()
                    }
                } else {
                    Rectangle()
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(Color.black)
                        .opacity(0.2)
                    Text("아직 게시글을 작성하지 않았습니다.")
                        .foregroundStyle(.white)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
