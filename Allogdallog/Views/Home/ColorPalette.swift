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
                
                if viewModel.selectedKeyword == "My" {
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

/*
struct CustomColorPicker: View {
    @Binding var myCustomColor: Color
    @State private var hue: Double = 0.5
    @State private var saturation: Double = 0.8
    @State private var brightness: Double = 0.8

    var body: some View {
        VStack {
            
            // 색상 선택을 위한 슬라이더 (Hue)
            Text("Hue")
                .font(.headline)
            Slider(value: $hue)
                .padding()
                .accentColor(Color(hue: hue, saturation: 1, brightness: 1))
            
            // 채도 선택 슬라이더 (Saturation)
            Text("Saturation")
                .font(.headline)
            Slider(value: $saturation)
                .padding()
                .accentColor(Color(hue: hue, saturation: saturation, brightness: 1))
            
            // 밝기 선택 슬라이더 (Brightness)
            Text("Brightness")
                .font(.headline)
            Slider(value: $brightness)
                .padding()
                .accentColor(Color(hue: hue, saturation: 1, brightness: brightness))
            // 선택한 색상 미리보기
            Text("Selected Color")
                .font(.headline)
            RoundedRectangle(cornerRadius: 10)
                .fill(myCustomColor)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
        }
        .padding()
        .onChange(of: hue) { _ in updateCustomColor() }
        .onChange(of: saturation) { _ in updateCustomColor() }
        .onChange(of: brightness) { _ in updateCustomColor() }
    }
    
    func updateCustomColor() {
        myCustomColor = Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}
 */

/*
struct CustomColorPicker: View {
    @Binding var selectedColor: Color
    @State private var colorPosition: CGFloat = 0.5
    
    var body: some View {
        VStack {
            Text("Gradient Color Picker")
                .font(.headline)
            
            // 그라데이션을 보여주는 뷰
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: 50)
                    .cornerRadius(10)
                    .overlay(
                        Capsule()
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0) // 드래그 제스처로 그라데이션에서 색상 선택
                            .onChanged { value in
                                let width = UIScreen.main.bounds.width - 40
                                let xPosition = max(0, min(value.location.x, width)) / width
                                colorPosition = xPosition
                                selectedColor = getColorAtPosition(position: xPosition)
                            }
                    )
                        
                // 선택된 색상의 위치를 나타내는 인디케이터
                Circle()
                    .fill(selectedColor)
                    .frame(width: 30, height: 30)
                    .offset(x: (colorPosition * (UIScreen.main.bounds.width - 60)) - (UIScreen.main.bounds.width / 2) + 30)
                    .shadow(radius: 5)
            }
            .padding()
                    
            // 선택된 색상 미리보기
            Text("Selected Color")
                .font(.headline)
                .padding(.top)
            RoundedRectangle(cornerRadius: 10)
                .fill(selectedColor)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
            
            Spacer()
        }
        .padding()
    }
    
    // 그라데이션 위치에 따른 색상 계산
    func getColorAtPosition(position: CGFloat) -> Color {
        let gradient = Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple])
        let colorPosition = min(max(0, position), 1)
        let index = Int(colorPosition * CGFloat(gradient.stops.count - 1))
        
        return gradient.stops[index].color
    }
}
 */

/*
struct CustomColorPicker: View {
    @Binding var selectedColor: Color
    @State private var hue: Double = 0.0 // Hue (0.0 ~ 1.0)
    @State private var saturation: Double = 1.0 // Saturation (0.0 ~ 1.0)
    @State private var brightness: Double = 1.0 // Brightness (0.0 ~ 1.0)
    
    var body: some View {
        VStack {
                    Text("Select Color")
                        .font(.headline)
                    
                    // 2D 색상 스펙트럼: 좌우(Hue), 상하(Saturation + Brightness)
                    GeometryReader { geometry in
                        ZStack {
                            // 스펙트럼 그리기
                            ForEach(0..<360) { angle in
                                let color = Color(hue: Double(angle) / 360.0, saturation: 1.0, brightness: 1.0)
                                Path { path in
                                    let width = geometry.size.width
                                    let height = geometry.size.height
                                    path.addRect(CGRect(x: CGFloat(angle) / 360.0 * width, y: 0, width: width / 360, height: height))
                                }
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white, color, Color.black]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            
                            // 선택한 색상 표시 (원)
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .position(
                                    x: CGFloat(hue) * geometry.size.width,
                                    y: (1.0 - brightness) * geometry.size.height
                                )
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let xPosition = min(max(0, value.location.x / geometry.size.width), 1)
                                            let yPosition = min(max(0, value.location.y / geometry.size.height), 1)
                                            
                                            hue = Double(xPosition) // 좌우로 hue 선택
                                            saturation = 1.0 // Saturation을 1로 고정
                                            brightness = Double(1 - yPosition) // 상하로 brightness 선택
                                        }
                                )
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding()
                    
                    // 선택된 색상 미리보기
                    Text("Selected Color")
                        .font(.headline)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedColor)
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    
                    Spacer()
                }
                .padding()
    }
}
*/

#Preview {
    ColorPalette()
}
