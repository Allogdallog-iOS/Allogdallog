//
//  ProfileEdit.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct ProfileEdit: View {
    
    @StateObject private var profileviewModel: ProfileViewModel
    @EnvironmentObject private var viewModel: SignUpViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isImagePickerPresented = false
    
    
    init(user: User) {
        _profileviewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        
        VStack {
            HStack (alignment: .top) {
                Text("프로필 편집")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                
                Spacer()
                
                Button(action: {
                    profileviewModel.editProfileUpload{ success in
                        if success {
                            dismiss() // 프로필 수정이 완료된 후 창을 닫음
                        } else {
                            print("프로필 수정 실패")
                        }
                    }
                })
                {
                    Image(systemName: "checkmark")
                        .frame(width: 25, height: 25)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                }.padding(.vertical, 5)
                    .padding(.horizontal, 15)
                
                
            }
            Divider()
            
            VStack (spacing: 20){
                
                if let image = profileviewModel.profileImage {
                    Button(action : {
                        profileviewModel.isImagePickerPresented
                            .toggle()
                    }) {
                        ZStack { Image(uiImage: image)
                                .resizable()
                                .circularImage(size: 100)
                                //.frame(width: 100, height: 100)
                                .clipShape(Circle())
                            Image(systemName: "photo.badge.plus.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .offset(x: 35, y: 35)
                                .foregroundStyle(.black)
                        }
                    }.padding()
                }
                
                /* if let imageUrl = profileviewModel.user.profileImageUrl, let url = URL(string: imageUrl) {
                 Button(action: {
                 profileviewModel.isImagePickerPresented.toggle()
                 }) {
                 ZStack {                                    AsyncImage(url: url) { image in
                 image
                 .resizable()
                 .circularImage(size: 100)
                 //.padding(.top)
                 //.padding(.leading)
                 //.clipShape(Circle())
                 } placeholder: {
                 Image(systemName: "person.circle.fill")
                 .resizable()
                 .frame(width: 100, height: 100)
                 .foregroundStyle(Color.myLightGray)
                 Image(systemName: "photo.badge.plus.fill")
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 30)
                 .offset(x: 35, y: 35)
                 .foregroundStyle(.gray)                            }
                 Image(systemName: "photo.badge.plus.fill")
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 30)
                 .offset(x: 35, y: 35)
                 .foregroundStyle(.black)
                 //.resizable()
                 //.frame(width: 100, height: 100)
                 //.clipShape(Circle())
                 }
                 }*/
                else {
                    Button(action: {
                        profileviewModel.isImagePickerPresented.toggle()
                    }) {
                        ZStack {
                            
                            if let imageUrl = profileviewModel.user.profileImageUrl, let url = URL(string: imageUrl)
                                
                            { AsyncImage(url: url) { image in
                                ZStack {
                                    // 원형 배경을 만들기
                                    Circle()
                                        .frame(width: 100, height: 100) // 최종적으로 보여줄 크기
                                        .foregroundColor(Color.clear) // 투명한 배경
                                    
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle()).mask(Circle().frame(width: 100, height: 100)) // 50x50 영역만 보여주도록 마스크 적용
                                }.frame(width: 100, height: 100)
                            } placeholder: {
                                ZStack {
                                    // 원형 배경을 만들기
                                    Circle()
                                        .frame(width: 100, height: 100) // 최종적으로 보여줄 크기
                                        .foregroundColor(Color.clear) // 투명한 배경
                                    
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle()).mask(Circle().frame(width: 100, height: 100)) // 50x50 영역만 보여주도록 마스크 적용
                                        .foregroundStyle(Color.myLightGray)
                                }.frame(width: 100, height: 100)
                                
                                Image(systemName: "photo.badge.plus.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .offset(x: 35, y: 35)
                                .foregroundStyle(.gray)                            }
                                Image(systemName: "photo.badge.plus.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .offset(x: 35, y: 35)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }.padding()
                        .sheet(isPresented: $profileviewModel.isImagePickerPresented) {
                            ImagePicker(image: $profileviewModel.profileImage,  isPresented:$profileviewModel.isImagePickerPresented) .onDisappear {
                                if profileviewModel.profileImage == nil {
                                    profileviewModel.profileImage = nil
                                }
                            }
                        }
                }
                
                VStack {
                    HStack{
                        Text("닉네임")
                            .padding(.leading)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 15)
                        
                        Spacer()
                    }
                    
                    TextField(profileviewModel.user.nickname, text: $profileviewModel.nickname).customTextFieldStyle(height: 50)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                        .padding(.horizontal, 20)
                }
            }
            Spacer()
            
        }
        .onAppear{
            profileviewModel.fetchUserData()
        }
    }
}
