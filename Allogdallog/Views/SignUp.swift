//
//  SignUp.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import SwiftUI

struct SignUp: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 25) {
            
            Text("회원가입")
                .font(.title2)
                .fontWeight(.semibold)
            
            if let image = viewModel.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Button(action: {
                    viewModel.isImagePickerPresented.toggle()
                }) {
                    ZStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.myLightGray)
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
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.myLightGray)
                )
            SecureField("비밀번호", text: $viewModel.password)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.myLightGray)
                )
            TextField("닉네임", text: $viewModel.nickname)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.myLightGray)
                )
            
            Button(action: {
                viewModel.signUp()
            }) {
                Text("회원가입")
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
        }
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(image: $viewModel.profileImage, isPresented: $viewModel.isImagePickerPresented)
        }
    }
}


#Preview {
    SignUp()
}
