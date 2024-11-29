//
//  ColorPaletteModify.swift
//  Allogdallog
//
//  Created by 믕진희 on 11/25/24.
//

import SwiftUI

struct ColorPaletteModify: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedColor: Color = Color.blue
    @State private var myNewColor: Color = Color.white
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count:5)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.isColorPaletteOpen.toggle()
                }) {
                    ZStack {
                        Ellipse()
                            .stroke(.black)
                            .frame(width:50, height: 25)
                        Image(systemName: "checkmark")
                            .frame(width: 25, height: 25)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }
                    .padding()
                }
            }
            Spacer()
            ZStack {
                Image(systemName: viewModel.pastSelecteShape)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(Color(hex: viewModel.clickedPost.todayColor))
                if Color(hex: viewModel.clickedPost.todayColor) == Color.white {
                    let imageName = viewModel.clickedPost.todayShape.replacingOccurrences(of: ".fill", with: "")
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundStyle(.myGray)
                }
            }
            .frame(height: 190)
            Spacer()
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(viewModel.paletteKeys), id: \.self) { keyword in
                            Button(action: {
                                viewModel.selectedKeyword = keyword
                            }) {
                                Text(keyword)
                                    .font(.caption)
                                    .foregroundStyle(viewModel.selectedKeyword == keyword ? Color.black : Color.myGray)
                                    .padding(14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 100)
                                            .stroke(viewModel.selectedKeyword == keyword ? Color.black : Color.myGray)
                                    )
                            }
                        }
                    }
                    .padding(10)
                }
                
                if viewModel.selectedKeyword == "커스텀" {
                    HStack {
                        Spacer()
                        ColorPicker("", selection: $myNewColor)
                            .frame(width: 35)
                            .padding(.trailing)
                        Button(action: {
                            viewModel.addMyNewColor(color: myNewColor.toHextString())
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(.black)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "plus")
                                    .frame(width: 26, height: 26)
                                    .foregroundStyle(.black)
                            }
                        }
                        Spacer()
                    }
                    .frame(height: 50)
                    .padding(.bottom, 10)
                }
                
                if let selectedColors = viewModel.colorPalettes[viewModel.selectedKeyword] {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(selectedColors, id:\.self) { color in
                                Button(action: {
                                    viewModel.pastSelectedColor = color
                                    viewModel.clickedPost.todayColor = color.toHextString()
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 36, height: 36)
                                        if color.toHextString() == "#FFFFFF" {
                                            Circle()
                                                .stroke(.myGray)
                                                .frame(width: 36, height: 36)
                                        }
                                        if color == viewModel.pastSelectedColor {
                                            if color.toHextString() == "#FFFFFF" {
                                                Circle()
                                                    .stroke(.myGray, lineWidth: 2)
                                                    .frame(width: 30, height: 30)
                                            } else {
                                                Circle()
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 30, height: 30)
                                            }
                                        }
                                    }
                                    .simultaneousGesture(
                                        LongPressGesture(minimumDuration: 1.0)
                                            .onEnded { _ in
                                                withAnimation {
                                                    viewModel.deleteMyColor(color: color.toHextString())
                                                }
                                            }
                                        
                                    )
                                    /*
                                    .onLongPressGesture(minimumDuration: 1.0) {
                                        if viewModel.selectedKeyword == "My" {
                                            viewModel.deleteMyColor(color: color.toHextString())
                                                
                                            Button(action: {
                                                viewModel.deleteMyColor(color: color.toHextString())
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundStyle(.myLightGray)
                                                        .frame(width: 35, height: 20)
                                                }
                                                Text("삭제")
                                                    .gmarketSans(type: .medium, size: 15)
                                            }
                                                
                                        }
                                    }
                                    */
                                    
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: 300)
        }
    }
}

#Preview {
    ColorPaletteModify()
}
