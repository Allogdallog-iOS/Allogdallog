//
//  SignUp.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import SwiftUI

struct SignUp: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Text("회원가입")
                .gmarketSans(type: .bold, size: 20)
            
            if let image = viewModel.profileImage {
                Button(action: {
                    viewModel.isImagePickerPresented.toggle()
                }) {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                }
            } else {
                Button(action: {
                    viewModel.isImagePickerPresented.toggle()
                }) {
                    ZStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.myLightGray)
                        Image(systemName: "photo.badge.plus.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .offset(x: 35, y: 35)
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            TextField("이메일", text: $viewModel.email)
                .customTextFieldStyle(height: 50)
                .gmarketSans(type: .medium, size: 15)
            SecureField("비밀번호", text: $viewModel.password)
                .customTextFieldStyle(height: 50)
                .gmarketSans(type: .medium, size: 15)
            TextField("닉네임", text: $viewModel.nickname)
                .customTextFieldStyle(height: 50)
                .gmarketSans(type: .medium, size: 15)
            
            Button(action: {
                viewModel.signUp()
            }) {
                Text("회원가입")
                    .gmarketSans(type: .medium, size: 15)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            } else {
                Text(" ")
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(image: $viewModel.profileImage, isPresented: $viewModel.isImagePickerPresented)
        }
        .onReceive(viewModel.$signUpComplete, perform: { complete in
            if complete {
                dismiss()
            }
        })
    }
}


#Preview {
    SignUp()
}
