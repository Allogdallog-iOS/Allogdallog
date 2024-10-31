//
//  DateClickPopUp.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/8/24.
//

import SwiftUI

struct DateClickPopUp: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject private var viewModel: MyCalendarViewModel
    @EnvironmentObject var tabSelection: TabSelectionManager
    @Binding var isPopUpOpen: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("\(viewModel.formateDateToString(viewModel.clickedPost?.todayDate ?? Date()))")
                        .padding()
                        .instrumentSansItalic(type: .semiBold, size: 20)
                    HStack(alignment: .center) {
                        Spacer()
                        VStack {
                            if let todayShape = viewModel.clickedPost?.todayShape {
                                if todayShape.isEmpty {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundStyle(Color(hex: viewModel.clickedPost?.todayColor ?? "#000000"))
                                } else {
                                    Image(systemName: viewModel.clickedPost?.todayShape ?? "circle.fill")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundStyle(Color(hex: viewModel.clickedPost?.todayColor ?? "#000000"))
                                }
                            }
                        }
                        .frame(height: 140)
                        Spacer()
                        if let url = URL(string: viewModel.clickedPost?.todayImgUrl ?? "") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: 100, height: 140)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black)
                                    )
                            } placeholder: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black)
                                        .frame(width: 100, height: 140)
                                    Image(systemName: "photo")
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        Spacer()
                        VStack {
                            Text("\(viewModel.clickedPost?.todayText ?? "")")
                                .font(.system(size: 35))
                        }
                        .frame(height: 140)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    ScrollView {
                        if !(viewModel.clickedPost?.todayComments.isEmpty ?? true) {
                            ForEach(viewModel.clickedPost?.todayComments ?? []) { comment in
                                HStack {
                                    if let url = URL(string: comment.fromUserImgUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .circularImage(size: 35)
                                                .overlay(
                                                    Circle()
                                                        .stroke(.black)
                                                        .frame(width: 35, height: 35)
                                                )
                                        } placeholder: {
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 35)
                                                .overlay(
                                                    Circle()
                                                        .stroke(.black)
                                                        .frame(width: 35, height: 35)
                                                )
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    VStack {
                                        HStack {
                                            Text("\(comment.fromUserNick)")
                                                .gmarketSans(type: .bold, size: 10)
                                            Spacer()
                                        }
                                        .padding(.bottom, 3)
                                        HStack {
                                            Text("\(comment.comment)")
                                                .gmarketSans(type: .medium, size: 10)
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(height: 30.0)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(.opacity(0.05))
                                        .stroke(.gray)
                                )
                                .padding(.horizontal, 10.0)
                                .padding(.vertical, 3.0)
                            }
                        }
                    }
                }
                .frame(width: 250)
            }
            HStack {
                NavigationLink(destination: MyDailyRecordModify().environmentObject(homeViewModel), label: {
                    Image(systemName: "pencil")
                        .foregroundStyle(.black)
                    Text("편집")
                        .gmarketSans(type: .medium, size: 13)
                        .foregroundStyle(.black)
        
                })
                Spacer()
                Button(action: {
                    viewModel.deletePost()
                    viewModel.fetchPostForMonth(viewModel.month)
                    isPopUpOpen.toggle()
                }) {
                    HStack {
                        Text("삭제")
                            .gmarketSans(type: .medium, size: 13)
                            .foregroundStyle(.red)
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 50)
        }
    }
}
