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
                    .padding(.horizontal)
            } else {
                Button(action: {
                    viewModel.isImagePickerPresented.toggle()
                }) {
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
            }
            
            TextField("이메일", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            SecureField("비밀번호", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            TextField("닉네임", text: $viewModel.nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                viewModel.signUp()
            }) {
                Text("회원가입")
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
            }
            .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(image: $viewModel.profileImage, isPresented: $viewModel.isImagePickerPresented)
        }
    }
}

#Preview {
    SignUp()
}
