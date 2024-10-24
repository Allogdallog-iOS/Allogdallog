//
//  WeeklyRecord.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/31/24.
//

import SwiftUI

struct WeeklyRecord: View {
    
    @EnvironmentObject private var viewModel: MyCalendarViewModel
    
    var body: some View {
        VStack {
            Text("This Week")
                .instrumentSansItalic(type: .semiBold, size: 17)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity,
                       alignment: .center)
            
            if viewModel.weekPosts.isEmpty {
                // 주간 기록이 없을 때
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black)
                            .frame(width: 340, height: 95)
                        VStack(alignment: .center) {
                        Text("이번 주에는 아직 기록을 남기지 않았어요.")
                            .instrumentSerif(type: .regular, size: 16)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity,
                                   alignment: .center)
                            //.padding()
                        Text("오늘의 기록을 남겨볼까요?")
                            .instrumentSerif(type: .regular, size: 16)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity,
                                   alignment: .center)
                    }
                }
                
            } else {
                           
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.weekPosts.indices, id: \.self) { index in
                        let post = viewModel.weekPosts[index]
                        Button(action: {
                            
                        }) {
                            VStack(alignment: .center) {
                                ZStack {
                                    Circle()
                                        .frame(width: 61, height: 61)
                                        .foregroundStyle(Color(hex:post.todayColor))
                                        .blur(radius: 5)
                                    Circle()
                                        .frame(width: 59, height: 59)
                                        .foregroundStyle(.white)
                                        .overlay(
                                            Circle()
                                                .stroke(.black)
                                        )
                                    if let url = URL(string: post.todayImgUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .frame(width: 30, height: 45)
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .overlay(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(.black)
                                                )
                                        } placeholder: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.black)
                                                    .frame(width: 30, height: 45)
                                                Image(systemName: "photo")
                                                    .foregroundStyle(.black)
                                            }
                                        }
                                    }
                                    Text(post.todayText)
                                        .offset(x: 15, y: 20)
                                    
                                }
                                Text(viewModel.getDayOfWeek(for: post.todayDate))
                                    .instrumentSerif(type: .regular, size: 12)
                                    .foregroundStyle(.black)
                            }
                            .frame(width: 72, height: 120)
                            .offset(y:(index % 2 == 0 ? -5 : 5))
                        }
                    }
                }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}


#Preview {
    WeeklyRecord()
}
