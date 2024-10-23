//
//  EmojiPalette.swift
//  Allogdallog
//
//  Created by 믕진희 on 10/17/24.
//

import SwiftUI

struct EmojiPalette: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var myNewEmoji: String = ""
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count:5)
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.isEmojiPaletteOpen.toggle()
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
            VStack {
                Text(viewModel.selectedEmoji)
                    .font(.system(size: 150))
            }
            .frame(height: 190)
            Spacer()
            VStack(alignment: .leading) {
                
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
                        TextField("", text:$myNewEmoji)
                        Button(action: {
                            viewModel.addMyNewEmoji(emoji: myNewEmoji)
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
                 
                if let selectedEmojis = viewModel.emojiPalettes[viewModel.selectedKeyword] {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(selectedEmojis, id:\.self) { emoji in
                                Button(action: {
                                    viewModel.selectedEmoji = emoji
                                }) {
                                    ZStack {
                                        Text(emoji)
                                            .font(.system(size: 32))
                                        if emoji == viewModel.selectedEmoji {
                                            Circle()
                                                .stroke(.myGray, lineWidth: 2)
                                                .frame(width: 36, height: 36)
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

#Preview {
    EmojiPalette()
}
