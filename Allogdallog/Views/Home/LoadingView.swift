//
//  LoadingView.swift
//  Allogdallog
//
//  Created by 김유진 on 10/19/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    var body: some View {
        ZStack {
            // 로딩 바를 나타낼 배경
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
                .opacity(isLoading ? 1 : 0) // 로딩 중에만 보이도록 설정

            // 로딩 바
            ZStack {
                Rectangle()
                        .foregroundColor(Color.white)
                        .edgesIgnoringSafeArea(.all) // Safe area를 무시하고 꽉 차게 만듭니다.
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5) // 크기 조절
                        .padding(.top, 0)
                        .opacity(isLoading ? 1 : 0)

                    Text("알록달록한 기록을 불러오는 중")
                        .font(.system(size: 15))
                        .foregroundColor(Color.gray)
                        .padding(.top, 15)
                        .opacity(isLoading ? 1 : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 부모 뷰의 중앙에 배치
            }
        }
        .onAppear {
            startLoading()
        }
    }

    func startLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}
