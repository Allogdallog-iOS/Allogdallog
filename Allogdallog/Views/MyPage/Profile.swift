//
//  Profile.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct Profile: View {
    
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel

    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    //var user: User
    
    var body: some View {
            
        VStack (alignment: .center) {
            HStack (alignment: .center) {
                VStack (alignment: .leading) {
                    if let imageUrl = viewModel.user.profileImageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            ZStack {
                                // 원형 배경을 만들기
                                Circle()
                                    .frame(width: 70, height: 70) // 최종적으로 보여줄 크기
                                    .foregroundColor(Color.clear) // 투명한 배경
                                
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle()).mask(Circle().frame(width: 70, height: 70)) // 50x50 영역만 보여주도록 마스크 적용
                            }.frame(width: 70, height: 70) // 최종적으로 ZStack의 크기 조정
                                .padding(.top)
                                .padding(.leading)
                        } placeholder: {
                            ZStack {
                                // 원형 배경을 만들기
                                Circle()
                                    .frame(width: 70, height: 70) // 최종적으로 보여줄 크기
                                    .foregroundColor(Color.clear) // 투명한 배경
                                
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle()).mask(Circle().frame(width: 70, height: 70)) // 50x50 영역만 보여주도록 마스크 적용
                            }.frame(width: 70, height: 70) // 최종적으로 ZStack의 크기 조정
                                .padding(.top)
                                .padding(.leading)
                        }
                    } else {
                        ZStack {
                            // 원형 배경을 만들기
                            Circle()
                                .frame(width: 70, height: 70) // 최종적으로 보여줄 크기
                                .foregroundColor(Color.clear) // 투명한 배경
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle()).mask(Circle().frame(width: 70, height: 70)) // 50x50 영역만 보여주도록 마스크 적용
                                .padding(.top)
                                .padding(.leading)
                        }.frame(width: 70, height: 70) // 최종적으로 ZStack의 크기 조정
                            .padding(.top)
                            .padding(.leading)

                    }
                }
                //.foregroundColor(.gray)
                //.frame(width: 60, height: 60)
                //.font(.system(size: 50))
                // .overlay(RoundedRectangle(cornerRadius: 40)
                // .stroke(Color.gray, lineWidth: 2))
                
                VStack(alignment: .leading) {
                    
                    Text(viewModel.user.nickname)
                        .font(.system(size: 22))
                        .padding(.top)
                        .padding(.leading)
                        .bold()
                    NavigationLink(destination: ProfileEdit(user: viewModel.user)){
                            Text("프로필 편집 >")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .padding(.leading)
                            Spacer()
                               }
                    
                        }
            }
            Divider()
                .padding(.top, 10)
            }
        }
    }
    

