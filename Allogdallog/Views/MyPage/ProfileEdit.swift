//
//  ProfileEdit.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct ProfileEdit: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack (alignment: .top){
            Text("프로필 편집")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
        }
        Divider()
        
        VStack{
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
                        Image(systemName: "person.circle.fill")
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
        }
        
        
        VStack (alignment: .leading){
            Text("닉네임")
                .padding(.leading)
                .fontWeight(.semibold)
        }
        
        
        
    }
}

#Preview {
    ProfileEdit()
}
