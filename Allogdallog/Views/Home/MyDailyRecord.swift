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
        VStack() {
            Text("Today's Me")
                .instrumentSansItalic(type:.bold, size: 30)
                .padding()
            Spacer()
            HStack {
                VStack {
                    Text("color")
                        .instrumentSerif(size: 24)
                    Spacer()
                    HStack {
                        Spacer()
                        ColorPicker("", selection: $viewModel.selectedColor)
                            .frame(height: 80)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(height: 200)
                    .disabled(viewModel.postButtonsDisabled)
                    
                }
                VStack {
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
                                .frame(width: 155, height: 200)
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
                                    .frame(width: 155, height: 200)
                                Image(systemName: "photo.badge.plus.fill")
                                    .foregroundStyle(.black)
                            }
                        }
                        .disabled(viewModel.postButtonsDisabled)
                    }
                }
                VStack {
                    Text("emoji")
                        .instrumentSerif(size: 24)
                    Spacer()
                    VStack(alignment: .center) {
                        TextEditor(text: $viewModel.todayPost.todayText)
                            .frame(height: 80)
                            .font(.system(size: 50))
                            .disabled(viewModel.postButtonsDisabled)
                    }
                    .frame(height: 200)
                }
            }
            .frame(height: 250)
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
                .frame(width: 155)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

