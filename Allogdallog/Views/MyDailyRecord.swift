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
            Text("오늘의 나는?")
                .font(.title2)
                .fontWeight(.semibold)
            HStack {
                Spacer()
                Button(action: {
                    viewModel.buttonsDisabled.toggle()
                }) {
                    Image(systemName: "pencil")
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                }
                Button(action: {
                    viewModel.uploadPost()
                }) {
                    Image(systemName: "checkmark")
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                }
            }
            HStack {
                if let image = viewModel.todayImage {
                    Button(action : {
                        viewModel.isImagePickerPresented
                            .toggle()
                    }) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 165, height: 215)
                            .border(.myGray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(viewModel.buttonsDisabled)
                } else {
                    Button(action: {
                        viewModel.isImagePickerPresented
                            .toggle()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.myGray)
                                .frame(width: 165, height: 215)
                            Image(systemName: "photo.badge.plus.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                    .disabled(viewModel.buttonsDisabled)
                }
                Spacer()
                VStack {
                    HStack {
                        ColorPicker("\(viewModel.selectedColor.toHextString())", selection: $viewModel.selectedColor)
                    }
                    .disabled(viewModel.buttonsDisabled)
                    .padding()
                    .frame(width: 150, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.myGray)
                    )
                    Spacer()
                    CustomTextEditor(text: $viewModel.todayComment)
                        .frame(width: 150, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.myGray)
                        )
                        .disabled(viewModel.buttonsDisabled)
                }
            }
            .frame(height: 215)
            .sheet(isPresented: $viewModel.isImagePickerPresented) {
                ImagePicker(image: $viewModel.todayImage, isPresented: $viewModel.isImagePickerPresented)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.horizontal, 10)
        .frame(height: 400)
    }
}

