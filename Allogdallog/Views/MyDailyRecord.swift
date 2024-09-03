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
            Spacer()
            Text("오늘의 나는?")
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            HStack {
                if let image = viewModel.todayImage {
                    Button(action : {
                        viewModel.isImagePickerPresented
                            .toggle()
                    }) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .border(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else {
                    Button(action: {
                        viewModel.isImagePickerPresented
                            .toggle()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.myLightGray)
                                .frame(width: 150, height: 200)
                            Image(systemName: "photo.badge.plus.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                Spacer()
                VStack {
                    /*
                    if viewModel.user.postUploaded {
                        HStack {
                            ColorPicker("\(String(describing: viewModel.selectedPost?.todayColor))", selection: $viewModel.selectedColor)
                        }
                        .padding()
                        .frame(width: 170, height: 45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.myLightGray)
                        )
                        Spacer()
                        
                        
                    }
                     */
                    HStack {
                        //Text(viewModel.todayColor)
                        ColorPicker("\(viewModel.selectedColor.toHextString())", selection: $viewModel.selectedColor)
                    }
                    .padding()
                    .frame(width: 170, height: 45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.myLightGray)
                    )
                    Spacer()
                                    
                    CustomTextEditor(text: $viewModel.todayComment)
                        .frame(width: 170, height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.myLightGray)
                        )
                }
            }
            .frame(height: 200)
            .sheet(isPresented: $viewModel.isImagePickerPresented) {
                ImagePicker(image: $viewModel.todayImage, isPresented: $viewModel.isImagePickerPresented)
            }
            Spacer()
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            } else {
                Text(" ")
            }
            Spacer()
            Button(action: {
                viewModel.uploadPost()
            }) {
                Text("업로드")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
            }
        }
        .padding(.horizontal)
        .frame(height: 300)
    }
}

