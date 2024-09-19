//
//  MyPage.swift
//  Allogdallog
//
//  Created by 믕진희 on 6/17/24.
//

import SwiftUI

struct MyPage: View {
    
    @State private var index = 0
    
    var body: some View {
        TabView(selection: $index) {
            HStack (alignment: .top) {
                Text("마이페이지")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 0)
                
                Spacer()
                
                Image(systemName: "bell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 0)
                
            }
            Divider()
        }
    }
}

    



