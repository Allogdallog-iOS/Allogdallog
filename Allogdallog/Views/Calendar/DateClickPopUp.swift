//
//  DateClickPopUp.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/8/24.
//

import SwiftUI

struct DateClickPopUp: View {
    
    @EnvironmentObject private var viewModel: MyCalendarViewModel
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text("\(viewModel.formateDateToString(viewModel.clickedPost?.todayDate ?? Date()))")
                    .padding()
                    .instrumentSansItalic(type: .semiBold, size: 20)
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Circle()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color(hex: viewModel.clickedPost?.todayColor ?? "#000000"))
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
                                    } placeholder: {
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 35)
                                    }
                                    .padding(.trailing, 10.0)
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
                                            .fontWeight(.semibold)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            .frame(height: 25.0)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.opacity(0.05))
                                    .stroke(.gray)
                            )
                            .padding([.leading, .trailing], 10.0)
                        }
                    }
                }
            }
            .frame(width: 250)
        }
    }
}
