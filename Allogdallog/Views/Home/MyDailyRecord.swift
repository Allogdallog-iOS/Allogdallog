//
//  DailyRecord.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/31/24.
//

import SwiftUI

struct MyDailyRecord: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    //@State private var isLoading = true // 로딩 상태 변수
    
    var body: some View {
        NavigationLink(destination: MyDailyRecordDetail().environmentObject(viewModel), label: {
            VStack {
                Text("오늘의 나는?")
                    .gmarketSans(type: .bold, size: 22)
                    .foregroundStyle(.black)
                    .padding()
                
                HStack() {
                    VStack(alignment: .center) {
                        Text("색상")
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundStyle(.myDarkGray)
                        Spacer()
                        HStack {
                            Image(systemName: (viewModel.user.postUploaded ? viewModel.todayPost.todayShape : "circle.fill"))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(viewModel.user.postUploaded ? Color(hex: viewModel.todayPost.todayColor) : Color.blue)
                        }
                        .frame(height: 200)
                    }
                    .padding(.leading, 10)
                    Spacer()
                    VStack {
                        Text("사진")
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundStyle(.myDarkGray)
                        Spacer()
                        VStack(alignment: .center) {
                            if viewModel.user.postUploaded {
                                if let url = URL(string: viewModel.todayPost.todayImgUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 160, height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black)
                                            )
                                    } placeholder: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black)
                                                .frame(width: 160, height: 200)
                                            Image(systemName: "photo.badge.plus.fill")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black)
                                        .frame(width: 160, height: 200)
                                    Image(systemName: "photo.badge.plus.fill")
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        .frame(height: 200)
                        
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("이모티콘")
                            .gmarketSans(type: .medium, size: 15)
                            .foregroundStyle(.myDarkGray)
                        Spacer()
                        HStack(alignment: .center) {
                            Text(viewModel.user.postUploaded ? viewModel.todayPost.todayText : "😊")
                                .font(.system(size: 50))
                        }
                        .frame(height: 200)
                    }
                    .padding(.trailing, 10)
                }
                .frame(height: 230)
                .padding(.top, 10)
            }
        })
    }
}
