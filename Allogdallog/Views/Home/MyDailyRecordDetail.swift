//
//  MyDailyRecordDetail.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/10/24.
//

import SwiftUI

struct MyDailyRecordDetail: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let maxHeight = geometry.size.height - 20
                ScrollView {
                    VStack {
                        Text("\(viewModel.getDate())")
                            .instrumentSansItalic(type:.bold, size: 30)
                            .foregroundStyle(.black)
                            .padding()
                        HStack {
                            VStack(alignment: .center) {
                                Text("color")
                                    .instrumentSerif(size: 24)
                                Spacer()
                                HStack {
                                    Spacer()
                                    ColorPicker("", selection: $viewModel.selectedColor)
                                        .frame(height: 80)
                                    Spacer()
                                }
                                .frame(height: 230)
                                .disabled(viewModel.postButtonsDisabled)
                                Spacer()
                                
                            }
                            .frame(height: 300)
                            VStack() {
                                Text("picture")
                                    .instrumentSerif(size: 24)
                                Spacer()
                                if let image = viewModel.todayImage {
                                    Button(action : {
                                        viewModel.isImagePickerPresented
                                            .toggle()
                                    }) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 180, height: 230)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black)
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
                                                .frame(width: 180, height: 230)
                                            Image(systemName: "photo.badge.plus.fill")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    .disabled(viewModel.postButtonsDisabled)
                                }
                                Spacer()
                            }
                            .frame(height: 300)
                            VStack() {
                                Text("emoji")
                                    .instrumentSerif(size: 24)
                                Spacer()
                                HStack(alignment: .center) {
                                    Spacer()
                                    TextEditor(text: $viewModel.todayPost.todayText)
                                        .frame(height: 80)
                                        .font(.system(size: 50))
                                        .disabled(viewModel.postButtonsDisabled)
                                    Spacer()
                                }
                                .frame(height: 230)
                                Spacer()
                            }
                            .frame(height: 300)
                        }
                        .sheet(isPresented: $viewModel.isImagePickerPresented) {
                            ImagePicker(image: $viewModel.todayImage, isPresented: $viewModel.isImagePickerPresented)
                        }
                        Spacer()
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
                            .frame(width: 180)
                            Spacer()
                        }
                        Spacer()
                        Divider()
                    }
                    .frame(height: maxHeight * 0.65)
                    ScrollView {
                        VStack {
                            if !viewModel.todayPost.todayComments.isEmpty {
                                ForEach(viewModel.todayPost.todayComments) { comment in
                                    ZStack {
                                        LinearGradient(colors: [Color.white, Color(hex: viewModel.todayPost.todayColor)], startPoint: .top, endPoint: .bottom)
                                            .frame(height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                        HStack {
                                            if let url = URL(string: comment.fromUserImgUrl) {
                                                AsyncImage(url: url) { image in
                                                    image
                                                        .resizable()
                                                        .circularImage(size: 45)
                                                } placeholder: {
                                                    Image(systemName: "person.circle")
                                                        .circularImage(size: 45)
                                                }
                                            } else {
                                                Image(systemName: "person.circle")
                                                    .circularImage(size: 45)
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
                    .frame(height: maxHeight * 0.35)
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .padding(.horizontal, 20)
    }
}

