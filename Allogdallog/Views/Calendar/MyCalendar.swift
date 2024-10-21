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
    @State private var clickedCurrentDate: Date?
    @State private var isPopUpOpen: Bool = false
    @State private var isLoading = true
    
    init(selectedUserId: String) {
        _viewModel = StateObject(wrappedValue: MyCalendarViewModel(selectedUserId: selectedUserId))
    }
    
    var body: some View {
        ZStack {
                   if isLoading {
                       // 로딩 중일 때는 LoadingView를 표시
                       LoadingView()
                   } else {
                       // 로딩이 끝났을 때 홈뷰 내용 표시
                       ZStack {
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
                           Color.black.opacity(isPopUpOpen ? 0.3 : 0)
                               .ignoresSafeArea(edges: .all)
                               .onTapGesture {
                                   isPopUpOpen.toggle()
                               }
                           
                           if isPopUpOpen {
                               DateClickPopUp()
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
            // 데이터 로딩을 시뮬레이션하거나 실제 네트워크 요청을 이곳에 추가합니다.
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
                    .instrumentSansItalic(type: .bold, size: 30)
                    .padding(.bottom)
                Button(action: {
                    viewModel.changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.black)
                }
                .padding(.leading, 10)
                Spacer()
            }
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
        let lastDayOfMonthBefore = viewModel.numberOfDays(in: viewModel.previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekDay) / 7))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekDay)
        
        return LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7)) {
            ForEach(-firstWeekDay ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = viewModel.getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        //let clicked = clickedCurrentDate == date
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
                /*
                .onTapGesture {
                    if 0 <= index && index < daysInMonth {
                        let date = viewModel.getDate(for: index)
                        clickedCurrentDate = date
                        viewModel.clickedPost = viewModel.postForDate(for: date)
                    }
                }
                 */
            }
        }
    }

    
    private struct CellView: View {
        
        @EnvironmentObject var viewModel: MyCalendarViewModel
        @EnvironmentObject var homeViewModel: HomeViewModel
        
        var date: Date
        var day: Int
        var post: Post
        //var hasPosts: Bool
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
                        viewModel.clickedPost = viewModel.postForDate(for: self.date)
                        isPopUpOpen.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 41, height: 41)
                                .foregroundStyle(isCurrentMonthDay ? Color(hex:post.todayColor) : Color.gray)
                                .blur(radius: 10)
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
                                .instrumentSerif(type: .italic, size: 15)
                                .foregroundStyle(Color.white)
                        }
                    }
                    .disabled(!homeViewModel.isEqualWithSelectedId())
                }
                .frame(height: 70)
            } else {
                VStack {
                   Text("\(day)")
                        .instrumentSerif(type: .italic, size: 15)
                        .foregroundStyle(textColor)
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

    
    // 로딩 데이터를 처리하는 함수
    func loadData() {
        // 로딩 작업 시작 (네트워크 작업, 데이터 처리 등)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 로딩이 끝나면 isLoading을 false로 설정하여 로딩 화면을 숨김
            isLoading = false
        }
    }
}


