//
//  Calendar.swift
//  Allogdallog
//
//  Created by 믕진희 on 6/17/24.
//

import SwiftUI

struct MyCalendar: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @StateObject private var viewModel: MyCalendarViewModel
    
    init(selectedUserId: String) {
        _viewModel = StateObject(wrappedValue: MyCalendarViewModel(selectedUserId: selectedUserId))
    }
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
        }
        .padding(.horizontal, 15)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    viewModel.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -50 {
                        viewModel.changeMonth(by: 1)
                    } else if gesture.translation.width > 50 {
                        viewModel.changeMonth(by: -1)
                    }
                    viewModel.offset = CGSize()
                }
        )
        .onChange(of: homeViewModel.user.selectedUser) {
            viewModel.selectedUserId = homeViewModel.user.selectedUser
            viewModel.fetchPostForMonth(viewModel.month)
        }
    }
    
    private var headerView: some View {
        VStack {
            Text(viewModel.month, formatter: Self.dateFormatter)
                .instrumentSansItalic(type: .bold, size: 30)
                .padding(.bottom)
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .instrumentSerif(size: 17)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    private var calendarGridView: some View {
        let daysInMonth: Int = viewModel.numberOfDays(in: viewModel.month)
        let firstWeekDay: Int = viewModel.firstWeekdayOfMonth(in: viewModel.month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                ForEach(0 ..< daysInMonth + firstWeekDay, id: \.self) { index in
                    if index < firstWeekDay {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(Color.clear)
                    } else {
                        let date = viewModel.getDate(for: index - firstWeekDay)
                        let day = index - firstWeekDay + 1
                        let hasPosts = viewModel.hasPosts(for: date)
                        
                        if hasPosts {
                            if let postForDate = viewModel.posts[date], let firstPost = postForDate.first {
                                CellView(day: day, hasPosts: hasPosts, post: firstPost)
                            }
                        } else {
                            CellView(day: day, hasPosts: hasPosts)
                        }
        
                    }
                }
            }
        }
    }
    
    private struct CellView: View {
        var day: Int
        var post: Post
        var hasPosts: Bool
        
        init(day: Int, hasPosts: Bool) {
            self.day = day
            self.hasPosts = hasPosts
            self.post = Post()
        }
        
        init(day: Int, hasPosts: Bool, post: Post) {
            self.day = day
            self.hasPosts = hasPosts
            self.post = post
        }
        
        var body: some View {
            if hasPosts {
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 41, height: 41)
                            .foregroundStyle(Color(hex:post.todayColor))
                            .blur(radius: 10)
                        if let url = URL(string: post.todayImgUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable().circularImage(size: 39)
                            } placeholder: {
                                Image(systemName: "questionmark.circle.fill")
                                    .circularImage(size: 39)
                            }
                        } else {
                            Image(systemName: "questionmark.circle.fill")
                                .circularImage(size: 39)
                        }
                        Text("\(post.todayText)")
                            .offset(x: 15, y: -15)
                        Text("\(day)")
                            .instrumentSerif(type: .italic, size: 15)
                            .foregroundStyle(Color.white)
                            .shadow(color: .myLightGray, radius: 5)
                    }
                }
                .frame(height: 70)
            } else {
                VStack {
                   Text("\(day)")
                        .instrumentSerif(type: .italic, size: 15)
                }
                .frame(height: 70)
            }
        }
    }
    
    /*Type1
     VStack {
         ZStack {
             Image("TestImage")
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(height: 35)
                 .clipShape(Circle())
                 .mask(
                     RadialGradient(gradient: Gradient(colors: [Color.black, Color.clear]), center: .center, startRadius: 100, endRadius: 150)
                 )
                 .padding(2)
                 .overlay(Circle().stroke(randomColor, lineWidth: 2).blur(radius: 0.3))
             Text("👍")
                 .offset(x: 15, y: -15)
         }
         if clicked {
             Text("Click")
                 .font(.caption)
                 .foregroundStyle(.red)
         }
     }
     .frame(height: 70)
     */
    
    /*Type2
     VStack {
         ZStack {
             Rectangle()
                 .fill(
                     LinearGradient(colors: [randomColor, Color.white], startPoint: .bottom, endPoint: .top)
                 )
                 .frame(height: 70)
             Image("TestImage")
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(height: 30)
                 .clipShape(Circle())
                 .overlay(Circle().stroke(.black))
             Text("👍")
                 .offset(x: 15, y: -15)
         }
         if clicked {
             Text("Click")
                 .font(.caption)
                 .foregroundStyle(.red)
         }
     }
     .overlay(Rectangle().stroke(.black))
     */
}


