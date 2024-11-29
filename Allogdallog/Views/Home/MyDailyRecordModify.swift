//
//  MyDailyRecordModify.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/31/24.
//

import SwiftUI

struct MyDailyRecordModify: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var currentShapeIndex = 0
    @State private var buttonDisabled = true
    
    
    
    var body: some View {
        VStack {
            Text(viewModel.getDateString(date: viewModel.clickedPost.todayDate))
                .instrumentSansItalic(type:.bold, size: 25)
                .foregroundStyle(.black)
                .padding()
            HStack {
                VStack(alignment: .center) {
                    Text("색상")
                        .gmarketSans(type: .medium, size: 17)
                        .foregroundStyle(.myDarkGray)
                    Spacer()
                    Button(action: {
                        viewModel.isColorPaletteOpen.toggle()
                    }) {
                        ZStack {
                            Image(systemName: viewModel.clickedPost.todayShape)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color(hex: viewModel.clickedPost.todayColor))
                        }
                    }
                    .onTapGesture(count: 2) {
                        currentShapeIndex = (currentShapeIndex + 1) % viewModel.shapes.count
                        viewModel.selectedShape = viewModel.shapes[currentShapeIndex]
                    }
                    .frame(width: 90, height: 210)
                    .disabled(buttonDisabled)
                    Spacer()
                    
                }
                .sheet(isPresented: $viewModel.isColorPaletteOpen) {
                    ColorPaletteModify()
                }
                .frame(height: 290)
                Spacer()
                VStack(alignment: .center) {
                    Text("사진")
                        .gmarketSans(type: .medium, size: 17)
                        .foregroundStyle(.myDarkGray)
                    Spacer()
                    if let image = viewModel.pastImage {
                        Button(action : {
                            viewModel.isImagePickerPresented
                                .toggle()
                        }) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 165, height: 210)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black)
                                    .frame(width: 165, height: 210)
                                )
                        }
                        .disabled(buttonDisabled)
                    } else {
                        Button(action: {
                            viewModel.isImagePickerPresented
                                .toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black)
                                    .frame(width: 165, height: 210)
                                Image(systemName: "photo.badge.plus.fill")
                                    .foregroundStyle(.black)
                            }
                        }
                        .disabled(buttonDisabled)
                    }
                    Spacer()
                }
                .sheet(isPresented: $viewModel.isImagePickerPresented) {
                    ImagePicker(image: $viewModel.pastImage, isPresented: $viewModel.isImagePickerPresented)
                }
                .frame(height: 290)
                Spacer()
                VStack(alignment: .center) {
                    Text("이모티콘")
                        .gmarketSans(type: .medium, size: 17)
                        .foregroundStyle(.myDarkGray)
                    Spacer()
                    Button(action: {
                        viewModel.isEmojiPaletteOpen.toggle()
                    }) {
                        Text(viewModel.clickedPost.todayText)
                            .font(.system(size: 50))
                    }
                    .disabled(buttonDisabled)
                    .frame(width: 90, height: 210)
                    Spacer()
                }
                .sheet(isPresented: $viewModel.isEmojiPaletteOpen) {
                    EmojiPaletteModify()
                }
                .frame(height: 290)
            }
            .padding(.bottom, 10)
            HStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        buttonDisabled.toggle()
                    }) {
                        ZStack {
                            Ellipse()
                                .stroke(.black)
                                .frame(width:50, height: 25)
                            Image(systemName: "pencil")
                                .frame(width: 25, height: 25)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                    }
                    Spacer()
                    Button(action: {
                        buttonDisabled.toggle()
                        viewModel.uploadPastPost(date: viewModel.getDateString(date: viewModel.clickedPost.todayDate))
                    }) {
                        ZStack {
                            Ellipse()
                                .stroke(.black)
                                .frame(width:50, height: 25)
                            Image(systemName: "checkmark")
                                .frame(width: 25, height: 25)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                    }
                    Spacer()
                }
                .frame(width: 165)
                Spacer()
            }
            .padding(.bottom, 5)
            Text(viewModel.errorMessage ?? " ")
                .foregroundStyle(.red)
                .gmarketSans(type: .medium, size: 15)
                .padding(.bottom, 5)
            Divider()
        }
        ScrollView {
            VStack {
                if !viewModel.clickedPost.todayComments.isEmpty {
                    ForEach(viewModel.clickedPost.todayComments) { comment in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black)
                                .frame(height: 60)
                                .padding(.vertical, 5)
                            HStack {
                                if let url = URL(string: comment.fromUserImgUrl) {
                                    AsyncImage(url: url) { image in
                                        ZStack {
                                            image
                                                .resizable()
                                                .circularImage(size: 45)
                                            Circle()
                                                .stroke(.black)
                                                .frame(width: 45, height: 45)
                                        }
                                    } placeholder: {
                                        ZStack {
                                            Image(systemName: "person.circle")
                                                .circularImage(size: 45)
                                            Circle()
                                                .stroke(.black)
                                                .frame(width: 45, height: 45)
                                        }
                                    }
                                } else {
                                    ZStack {
                                        Image(systemName: "person.circle")
                                            .circularImage(size: 45)
                                        Circle()
                                            .stroke(.black)
                                            .frame(width: 45, height: 45)
                                    }
                                }
                                VStack {
                                    HStack {
                                        Text("\(comment.fromUserNick)")
                                            .gmarketSans(type: .bold, size: 12)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(comment.comment)")
                                            .gmarketSans(type: .medium, size: 12)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            .padding(.leading, 10)
                        }
                        .padding(.horizontal, 7)
                    }
                }
            }
        }
        .onAppear {
            viewModel.pastSelecteShape = viewModel.clickedPost.todayShape
            currentShapeIndex = viewModel.shapes.firstIndex(of: viewModel.clickedPost.todayShape) ?? 0
        }
    }
}

