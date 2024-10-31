//
//  SignIn.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/9/24.
//

import SwiftUI
import FirebaseAuth

struct SignIn: View {
    
    @State private var email = ""
    @State private var password = ""
    @StateObject private var viewModel = SignInViewModel()
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 25) {
                Spacer()
                
                Text("로그인")
                    .gmarketSans(type: .bold, size: 20)
                TextField("이메일", text: $viewModel.email)
                    .customTextFieldStyle(height: 50)
                    .gmarketSans(type: .medium, size: 14)
                SecureField("비밀번호", text: $viewModel.password)
                    .customTextFieldStyle(height: 50)
                    .gmarketSans(type: .medium, size: 14)
                Button(action: {
                    viewModel.signIn()
                }) {
                    Text("로그인")
                        .gmarketSans(type: .medium, size: 15)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    if let user = userViewModel.user {
                        Home(user: user)
                    } else {
                        Text("데이터를 불러오는 중입니다.")
                            .onAppear {
                                if let userId = Auth.auth().currentUser?.uid {
                                    userViewModel.fetchUser(userId: userId)
                                } else {
                                    print("User is not logged in")
                                }
                            }
                    }
                }
                HStack {
                    Text("회원이 아니신가요?")
                        .gmarketSans(type: .medium, size: 12)
                        .foregroundStyle(.myGray)
                    NavigationLink(value: "SignUp") {
                        Text("회원가입")
                            .gmarketSans(type: .medium, size: 12)
                            .foregroundStyle(.gray)
                    }
                    .navigationDestination(for: String.self) { value in
                        if value == "SignUp" {
                            SignUp()
                        }
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
            .navigationBarBackButtonHidden()
            .padding(.horizontal)
        }
    }
}

#Preview {
    SignIn()
}
