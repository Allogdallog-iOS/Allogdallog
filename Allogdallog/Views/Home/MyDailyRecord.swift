//
//  DailyRecord.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/31/24.
//

import SwiftUI

struct MyDailyRecord: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        NavigationLink(destination: MyDailyRecordDetail().environmentObject(viewModel), label: {
            VStack {
                Text("Today's Me")
                    .instrumentSansItalic(type:.bold, size: 30)
                    .foregroundStyle(.black)
                    .padding()
                HStack() {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("color")
                            .instrumentSerif(size: 24)
                            .foregroundStyle(.black)
                        Spacer()
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(viewModel.user.postUploaded ? Color(hex: viewModel.todayPost.todayColor) : .black)
                                .blur(radius: 5)
                        }
                        .frame(height: 200)
                    }
                    Spacer()
                    VStack {
                        Text("picture")
                            .instrumentSerif(size: 24)
                            .foregroundStyle(.black)
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
                        Text("emoji")
                            .instrumentSerif(size: 24)
                            .foregroundStyle(.black)
                        Spacer()
                        HStack(alignment: .center) {
                            
                            Text(viewModel.user.postUploaded ? viewModel.todayPost.todayText : "")
                                .font(.system(size: 50))
                        }
                        .frame(height: 200)
                    }
                    Spacer()
                }
                .frame(height: 230)
            }
            .padding(.horizontal, 20)
        })
    }
}
