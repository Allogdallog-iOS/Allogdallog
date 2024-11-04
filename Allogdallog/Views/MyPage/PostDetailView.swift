//
//  PostDetailView.swift
//  Allogdallog
//
//  Created by 김유진 on 10/31/24.
//

import SwiftUI

struct PostDetailView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    //@EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject var tabSelection: TabSelectionManager
    
    var postId: String
    
    init(viewModel: HomeViewModel, postId: String) {
           self.viewModel = viewModel
           self.postId = postId
            //self.viewModel.detailPost = Post()
       }
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Image("image/logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 42)
                    .clipped()
                Spacer()
            }
            Divider()
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    if viewModel.selectedDate.isEmpty {
                        Text("\(viewModel.getDateString(date: Date()))")
                            .instrumentSansItalic(type:.bold, size: 25)
                    } else {
                        Text(viewModel.selectedDate)
                            .instrumentSansItalic(type:.bold, size: 25)
                    }
                    Spacer()
                }
                .padding(.vertical, 15)
                
                if viewModel.detailPost.id.isEmpty {
                    Text("Loading...")
                        .onAppear {
                            viewModel.detailPost = Post()
                            viewModel.navigateToPost(by: postId)
                        }
                } else {
                        HStack {
                        VStack(spacing: 0) {
                            Spacer()
                            Text("색상")
                                .gmarketSans(type: .medium, size: 15)
                                .foregroundStyle(.myDarkGray)
                            Spacer()
                            VStack(alignment: .center) {
                                Image(systemName: viewModel.detailPost.todayShape)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color(hex: viewModel.detailPost.todayColor))
                            }
                            .frame(height: 180)
                        }
                        Spacer()
                        VStack(spacing: 0) {
                            Spacer()
                            Text("사진")
                                .gmarketSans(type: .medium, size: 15)
                                .foregroundStyle(.myDarkGray)
                            Spacer()
                            if let url = URL(string: viewModel.detailPost.todayImgUrl) {
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
                        VStack(spacing: 0) {
                            Spacer()
                            Text("이모티콘")
                                .gmarketSans(type: .medium, size: 15)
                                .foregroundStyle(.myDarkGray)
                            Spacer()
                            VStack(alignment: .center) {
                                Text("\(viewModel.detailPost.todayText)")
                                    .frame(height: 80)
                                    .font(.system(size: 50))
                            }
                            .frame(height: 180)
                        }
                        //.padding(.trailing, 10)
                        }.frame(height: 230)
                    }
                //Spacer()
            }.padding(.bottom, 15)
            Spacer()
            DetailComments(viewModel: viewModel)
        }.padding()
            .onAppear {
                    viewModel.detailPost = Post()
                    viewModel.navigateToPost(by: postId)
                }
            //Spacer()
        }
    }
