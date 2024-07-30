//
//  SignIn.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import SwiftUI

struct SignIn: View {
    
    @State private var email = ""
    @State private var password = ""
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()
                
                Text("로그인")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                TextField("이메일", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.myLightGray)
                    )
                SecureField("비밀번호", text: $viewModel.password)
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.myLightGray)
                    )
                
                Button(action: {
                    viewModel.signIn()
                }) {
                    Text("로그인")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    Home()
                }
                
                NavigationLink(value: "SignUp") {
                    Text("회원가입")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .navigationDestination(for: String.self) { value in
                    if value == "SignUp" {
                        SignUp()
                    }
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
        }
    }
}

#Preview {
    SignIn()
}