//
//  MyFriends.swift
//  Allogdallog
//
//  Created by 믕진희 on 8/9/24.
//

import SwiftUI

struct MyFriends: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    Button(action : {
                        viewModel.user.selectedUser = viewModel.user.id
                        viewModel.fetchPost()
                    }) {
                        VStack {
                            if let imageUrl = viewModel.user.profileImageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case.empty:
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 2)
                                                .frame(width: 56, height: 56)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            ZStack {
                                                // 원형 배경을 만들기
                                                Circle()
                                                    .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                    .foregroundColor(Color.clear) // 투명한 배경
                                                
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .foregroundStyle(Color.myLightGray)
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.black)
                                                            .frame(width: 50, height: 50)
                                                    )
                                            }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                        }
                                    case .success(let image):
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 2)
                                                .frame(width: 56, height: 56)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            ZStack {
                                                // 원형 배경을 만들기
                                                Circle()
                                                    .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                    .foregroundColor(Color.clear) // 투명한 배경
                                                
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.black)
                                                            .frame(width: 50, height: 50)
                                                    )
                                            }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                        }
                                    case .failure:
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 2)
                                                .frame(width: 56, height: 56)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            ZStack {
                                                // 원형 배경을 만들기
                                                Circle()
                                                    .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                    .foregroundColor(Color.clear) // 투명한 배경
                                                
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .foregroundStyle(Color.myLightGray)
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.black)
                                                            .frame(width: 50, height: 50)
                                                    )
                                            }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                        }
                                    @unknown default:
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 2)
                                                .frame(width: 56, height: 56)
                                                .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                            ZStack {
                                                // 원형 배경을 만들기
                                                Circle()
                                                    .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                    .foregroundColor(Color.clear) // 투명한 배경
                                                
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .foregroundStyle(Color.myLightGray)
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.black)
                                                            .frame(width: 50, height: 50)
                                                    )
                                            }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                        }
                                    }
                                }
                            } else {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .frame(width: 56, height: 56)
                                        .foregroundColor(viewModel.user.selectedUser == viewModel.user.id ? viewModel.selectedColor : Color.clear)
                                    ZStack {
                                        // 원형 배경을 만들기
                                        Circle()
                                            .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                            .foregroundColor(Color.clear) // 투명한 배경
                                        
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .foregroundStyle(Color.myLightGray)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black)
                                                    .frame(width: 50, height: 50)
                                            )
                                    }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                }
                            }
                            
                            Text("\(viewModel.user.nickname)")
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                    }
                    ForEach(viewModel.user.friends) { friend in
                        Button(action: {
                            viewModel.user.selectedUser = friend.id
                            viewModel.selectedDate.removeAll()
                            viewModel.fetchFriendPost(date: viewModel.getTodayDateString())
                        }) {
                            VStack {
                                if let imageUrl = friend.profileImageUrl, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case.empty:
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 56, height: 56)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                ZStack {
                                                    // 원형 배경을 만들기
                                                    Circle()
                                                        .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                        .foregroundColor(Color.clear) // 투명한 배경
                                                    
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .foregroundStyle(Color.myLightGray)
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.black)
                                                                .frame(width: 50, height: 50)
                                                        )
                                                }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                            }
                                        case .success(let image):
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 56, height: 56)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                ZStack {
                                                    // 원형 배경을 만들기
                                                    Circle()
                                                        .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                        .foregroundColor(Color.clear) // 투명한 배경
                                                    
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .foregroundStyle(Color.myLightGray)
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.black)
                                                                .frame(width: 50, height: 50)
                                                        )
                                                }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                            }
                                        case .failure:
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 56, height: 56)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                ZStack {
                                                    // 원형 배경을 만들기
                                                    Circle()
                                                        .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                        .foregroundColor(Color.clear) // 투명한 배경
                                                    
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .foregroundStyle(Color.myLightGray)
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.black)
                                                                .frame(width: 50, height: 50)
                                                        )
                                                }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                            }
                                        @unknown default:
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: 56, height: 56)
                                                    .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                                ZStack {
                                                    // 원형 배경을 만들기
                                                    Circle()
                                                        .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                        .foregroundColor(Color.clear) // 투명한 배경
                                                    
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .foregroundStyle(Color.myLightGray)
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.black)
                                                                .frame(width: 50, height: 50)
                                                        )
                                                }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                            }
                                        }
                                    }
                                } else {
                                    ZStack {
                                        Circle()
                                            .stroke(lineWidth: 2)
                                            .frame(width: 56, height: 56)
                                            .foregroundColor(viewModel.user.selectedUser == friend.id ? viewModel.selectedColor : Color.clear)
                                        ZStack {
                                            // 원형 배경을 만들기
                                            Circle()
                                                .frame(width: 50, height: 50) // 최종적으로 보여줄 크기
                                                .foregroundColor(Color.clear) // 투명한 배경
                                            
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .foregroundStyle(Color.myLightGray)
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle()).mask(Circle().frame(width: 50, height: 50)) // 50x50 영역만 보여주도록 마스크 적용
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black)
                                                        .frame(width: 50, height: 50)
                                                )
                                        }.frame(width: 50, height: 50) // 최종적으로 ZStack의 크기 조정
                                    }
                                }
                                
                                Text(friend.nickname)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 18)
            }
        }
    }
}
