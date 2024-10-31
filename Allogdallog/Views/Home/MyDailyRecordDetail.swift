//
//  MyDailyRecordDetail.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/10/24.
//

import SwiftUI

struct MyDailyRecordDetail: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var currentShapeIndex = 0
    @State private var hasBeenTapped = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("\(viewModel.getDateString(date: Date()))")
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
                                    Image(systemName: viewModel.selectedShape)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(viewModel.selectedColor)
                                    if !hasBeenTapped && !viewModel.user.postUploaded {
                                        Text("두 번 클릭시 모양이 바뀌어요!")
                                            .gmarketSans(type: .medium, size: 10)
                                            .foregroundStyle(.myGray)
                                            .offset(y: -90)
                                    }
                                }
                            }
                            .onTapGesture(count: 2) {
                                hasBeenTapped = true
                                currentShapeIndex = (currentShapeIndex + 1) % viewModel.shapes.count
                                viewModel.selectedShape = viewModel.shapes[currentShapeIndex]
                            }
                            .frame(width: 90, height: 210)
                            .disabled(viewModel.postButtonsDisabled)
                            Spacer()
                            
                        }
                        .sheet(isPresented: $viewModel.isColorPaletteOpen) {
                            ColorPalette()
                        }
                        .frame(height: 290)
                        Spacer()
                        VStack(alignment: .center) {
                            Text("사진")
                                .gmarketSans(type: .medium, size: 17)
                                .foregroundStyle(.myDarkGray)
                            Spacer()
                            if let image = viewModel.todayImage {
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
                                .disabled(viewModel.postButtonsDisabled)
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
                                .disabled(viewModel.postButtonsDisabled)
                            }
                            Spacer()
                        }
                        .sheet(isPresented: $viewModel.isImagePickerPresented) {
                            ImagePicker(image: $viewModel.todayImage, isPresented: $viewModel.isImagePickerPresented)
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
                                Text(viewModel.selectedEmoji)
                                    .font(.system(size: 50))
                            }
                            .disabled(viewModel.postButtonsDisabled)
                            .frame(width: 90, height: 210)
                            Spacer()
                        }
                        .sheet(isPresented: $viewModel.isEmojiPaletteOpen) {
                            EmojiPalette()
                        }
                        .frame(height: 290)
                    }
                    .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if viewModel.user.postUploaded {
                                Button(action: {
                                    viewModel.postButtonsDisabled.toggle()
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
                                    viewModel.uploadPost()
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
                            } else {
                                Button(action: {
                                    viewModel.uploadPost()
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
                            }
                            Spacer()
                        }
                        .frame(width: 165)
                        Spacer()
                    }
                    .padding(.bottom, 5 )
                    Text(viewModel.errorMessage ?? " ")
                        .foregroundStyle(.red)
                        .gmarketSans(type: .medium, size: 15)
                        .padding(.bottom, 5)
                    Divider()
                }
                ScrollView {
                    VStack {
                        if !viewModel.todayPost.todayComments.isEmpty {
                            ForEach(viewModel.todayPost.todayComments) { comment in
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
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(comment.comment)")
                                                    .font(.caption)
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                }
                                .padding(.horizontal, 3)
                            }
                        }
                    }
                }
            }
            .environmentObject(viewModel)
            .ignoresSafeArea(.keyboard)
        }
        .padding(.horizontal, 20)
    }
}

