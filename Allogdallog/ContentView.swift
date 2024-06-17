//
//  ContentView.swift
//  Allogdallog
//
//  Created by 믕진희 on 5/16/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var index = 0
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(1...10, id: \.self) { index in
                        CircularButton(userName: "친구 \(index) ")
                    }
                }
            }
            .frame(height: 120.0)
            Divider()
            TabView(selection: $index) {
                Home()
                    .tabItem {
                        Label("Home", systemImage: "house.fill") }
                    .tag(1)
                Calendar()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar") }.tag(2)
            }
            .tint(Color.tabTint)
            
        }
        .padding()
    }
}

// 친구창
struct CircularButton: View {
    var userName: String
    
    var body: some View {
        // 친구 연동 필요
        VStack {
            Button(action: {
                
            }) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 75.0, height: 75.0)
                    .foregroundStyle(.gray)
            }
            Text(userName)
        }
    }
}

// 탭 바 클릭시
extension Color {
    static let tabtint = Color("TabTint")
}

#Preview {
    ContentView()
}
