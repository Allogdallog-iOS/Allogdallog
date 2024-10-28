//
//  ColorPalette.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/15/24.
//

import SwiftUI

struct ColorPalette: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
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
                Circle()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(viewModel.selectedColor)
                if viewModel.selectedColor == Color.white {
                    Circle()
                        .stroke(.myGray)
                        .frame(width: 150, height: 150)
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
                                    viewModel.selectedColor = color
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
                                        if color == viewModel.selectedColor {
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
