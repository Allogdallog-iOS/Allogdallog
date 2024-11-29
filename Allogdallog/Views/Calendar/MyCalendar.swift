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
    @EnvironmentObject var tabSelection: TabSelectionManager
    @State private var clickedCurrentDate: Date?
    @State private var isPopUpOpen: Bool = false
    @State private var isLoading = true
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: MyCalendarViewModel(user: user))
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
            } else {
                    ZStack {
                        VStack {
                            Spacer()
                            headerView
                            ScrollView {
                                calendarGridView
                            }
                            Spacer()
                        }
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
                            viewModel.user.selectedUser = homeViewModel.user.selectedUser
                            viewModel.fetchPostForMonth(viewModel.month)
                        }
                        Color.black.opacity(isPopUpOpen ? 0.3 : 0)
                            .ignoresSafeArea(edges: .all)
                            .onTapGesture {
                                isPopUpOpen.toggle()
                            }
                        
                        if isPopUpOpen {
                            DateClickPopUp(isPopUpOpen: $isPopUpOpen)
                                .transition(.scale)
                                .background(Color.white)
                                .frame(width: 250, height: 350.0)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 10)
                                .zIndex(1.0)
                        }
                    }
                }
        }.onAppear {
            loadData()
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
                .padding(.trailing, 10)
                Text(viewModel.month, formatter: Self.dateFormatter)
                    .instrumentSansItalic(type: .bold, size: 28)
                Button(action: {
                    viewModel.changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.black)
                }
                .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom)
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .gmarketSans(type: .medium, size: 15)
                        .foregroundStyle(.myDarkGray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    private var calendarGridView: some View {
        let daysInMonth: Int = viewModel.numberOfDays(in: viewModel.month)
        let firstWeekDay: Int = viewModel.firstWeekdayOfMonth(in: viewModel.month) - 1
        let lastDayOfMonthBefore = viewModel.numberOfDays(in: viewModel.previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekDay) / 7))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekDay)
        
        return LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7)) {
            ForEach(-firstWeekDay ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = viewModel.getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let postForDate = viewModel.postForDate(for: date)
                        
                        CellView(date: date, day: day, post: postForDate, isPopUpOpen: $isPopUpOpen)
    
                    } else if let prevMonthdate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: viewModel.previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthdate)
                        let postForDate = viewModel.postForDate(for: prevMonthdate)
                        CellView(date: prevMonthdate, day: day ,post: postForDate, isCurrentMonthDay: false, isPopUpOpen: $isPopUpOpen)
                    }
                }
            }
        }
    }

    
    private struct CellView: View {
        
        @EnvironmentObject var viewModel: MyCalendarViewModel
        @EnvironmentObject var homeViewModel: HomeViewModel
        @EnvironmentObject var tabSelection: TabSelectionManager
        
        var date: Date
        var day: Int
        var post: Post
        var isCurrentMonthDay: Bool
        var textColor: Color {
            if isCurrentMonthDay {
                return Color.black
            } else {
                return Color.gray
            }
        }
        @Binding var isPopUpOpen: Bool
        
        init(date: Date, day: Int, post: Post, isCurrentMonthDay: Bool, isPopUpOpen: Binding<Bool>) {
            self.date = date
            self.day = day
            self.post = post
            self.isCurrentMonthDay = isCurrentMonthDay
            self._isPopUpOpen = isPopUpOpen
        }
        
        init(date: Date, day: Int, post: Post, isPopUpOpen: Binding<Bool>) {
            self.date = date
            self.day = day
            self.post = post
            self.isCurrentMonthDay = true
            self._isPopUpOpen = isPopUpOpen
        }
        
        var body: some View {
            if !post.id.isEmpty {
                VStack {
                    Button(action: {
                        if homeViewModel.user.id == homeViewModel.user.selectedUser {
                            homeViewModel.clickedPost = self.post
                            homeViewModel.fetchPastPost()
                            viewModel.clickedPost = self.post
                            isPopUpOpen.toggle()
                        } else {
                            homeViewModel.selectedDate = viewModel.getDateString(date: self.date)
                            homeViewModel.fetchFriendPost(date: homeViewModel.selectedDate)
                            tabSelection.selectedTab = 0
                        }
                    }) {
                        ZStack {
                            Circle()
                                .stroke(isCurrentMonthDay ? Color(hex:post.todayColor) : Color.gray, lineWidth: 2)
                                .frame(width: 43, height: 43)
                                .foregroundStyle(isCurrentMonthDay ? Color(hex:post.todayColor) : Color.gray)
                            if let url = URL(string: post.todayImgUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable().circularImage(size: 39)
                                        .grayscale(isCurrentMonthDay ? 0.0 : 1.0)
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
                                .gmarketSans(type: .medium, size: 12)
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                .frame(height: 70)
            } else {
                VStack {
                   Text("\(day)")
                        .gmarketSans(type: .medium, size: 12)
                        .foregroundStyle(textColor)
                }
                .frame(height: 70)
            }
        }
    }
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
        }
    }
}


