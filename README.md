# 알록달록 (Allogdallog)

**알록달록**은 사용자가 이모지, 사진, 감정을 나타내는 색으로 하루를 기록하고, 한 달간의 감정과 추억을 시각적으로 확인할 수 있는 iOS 애플리케이션입니다. 간결한 사용자 경험과 직관적인 인터페이스를 통해 일상 기록을 더욱 쉽고 재미있게 만들어줍니다.

---

## 📋 **기능 소개**

### 1. **홈 화면**
- 당일의 게시글을 표시합니다.
- 게시글 작성, 수정, 삭제가 가능합니다.
- 감정 색상, 이모지, 사진을 추가하여 하루를 기록할 수 있습니다.
- 홈화면 하단을 통해 주간기록을 확인할 수 있습니다

### 2. **캘린더 화면**
- 한 달간 작성된 기록들을 캘린더 형식으로 한눈에 확인할 수 있습니다.
- 날짜별 기록 요약 및 세부 정보 팝업을 제공합니다.

### 3. **마이페이지**
- 사용자 정보 및 설정을 관리할 수 있습니다.
- 프로필 사진과 닉네임을 설정 및 변경 가능합니다.

---

## 💻 **기술 스택**

### **1. 프론트엔드**
- **SwiftUI**
  - 간결하고 직관적인 코드로 UI와 상태 관리를 구현.
  - `@State`, `@Binding`, `@ObservedObject`를 활용한 데이터 바인딩.

### **2. 백엔드**
- **Firebase Firestore**
  - 사용자 데이터 및 게시글 데이터를 실시간으로 관리.
  - 계층적 데이터 구조 (`posts/{userId}/posts/{postId}`)를 채택.
- **Firebase Storage**
  - 사용자 프로필 사진 및 게시글에 첨부된 이미지를 저장.

### **3. 설계 및 프로토타이핑**
- **Figma**
  - UI/UX 설계를 사전에 정의하고, 피드백을 기반으로 반복 개선.

---

## 🗂️ **프로젝트 구조**

```plaintext
├── Models
│   ├── Post.swift               // 게시글 데이터 모델
│   ├── User.swift               // 사용자 데이터 모델
│   ├── Friend.swift             // 사용자 친구 데이터 모델
│   ├── Comment.swift            // 게시글 댓글 데이터 모델
│   ├── AppNotification.swift    // 알림 데이터 모델
│   └── FriendRequest.swift      // 친구 신청 데이터 모델
├── ViewModels
│   ├── HomeViewModel.swift      // 홈 화면 데이터 관리
│   ├── CalendarViewModel.swift  // 캘린더 화면 데이터 관리
│   └── MyPageViewModel.swift    // 마이페이지 데이터 관리
├── Views
│   ├── Home                     // 홈 화면 UI
│   │    ├── Friends.swift       // 상단 친구 리스트 화면
│   │    ├── DailyRecord.swift   // 당일 기록 화면
│   │    ├── WeeklyRecord.swift  // 주간 기록 화면
│   │    ├── ColorPalette.swift  // 색상 선택 팔레트 화면
│   │    └── EmojiPalette.swift  // 이모지 선택 팔레트 화면
│   ├── Calendar                 // 캘린더 화면 UI
│   │    ├── MyCalendar.swift    // 캘린더 메인 화면
│   │    └── DateClickPopUp.swift // 날짜 클릭 팝업 화면
│   └── MyPage                   // 마이페이지 UI
│        ├── Profile.swift       // 프로필 화면
│        ├── ProfileEdit.swift   // 프로필 수정 화면
│        ├── FriendList.swift    // 친구 리스트 화면
│        ├── FriendSearch.swift  // 친구 찾기 화면
│        ├── Notification.swift  // 알림 화면
│        └── Setting.swift       // 설정 화면
├── Resources
│   └── Assets.xcassets          // 앱의 이미지 및 색상 리소스
└── AllogdallogApp.swift         // 앱의 진입점
```

---

## 🌟 **주요 특징**

1. **직관적인 UI/UX**
   - 감정 색상 선택, 이모지 추가 등 사용자의 감정을 쉽게 기록할 수 있도록 설계되었습니다.
   - 캘린더에서 한눈에 감정의 흐름을 확인 가능.

2. **실시간 데이터 동기화**
   - Firebase를 활용하여 게시글 작성/수정 시 즉각적으로 업데이트.

3. **확장 가능성**
   - 데이터 구조와 UI 설계를 확장 가능한 방식으로 구현하여 향후 새로운 기능 추가가 용이합니다.

---

## 🚀 **설치 및 실행**

### **1. 사전 준비**
- macOS가 설치된 시스템.
- Xcode 14 이상 설치.
- Firebase 프로젝트 설정(Cloud Firestore 및 Storage 활성화).

### **2. Firebase 설정**
1. Firebase 콘솔에서 프로젝트 생성.
2. Firestore와 Storage 활성화.
3. `GoogleService-Info.plist` 파일을 다운로드하여 프로젝트에 추가.

### **3. 프로젝트 실행**
1. GitHub에서 프로젝트 클론:
   ```bash
   git clone https://github.com/your-repo/allogdallog.git
   ```
2. Xcode에서 프로젝트 열기:
   ```bash
   open Allogdallog.xcodeproj
   ```
3. 시뮬레이터 또는 실제 디바이스에서 실행.

---

## 📖 **향후 계획**

1. **Android 버전 개발**
   - Kotlin 및 Jetpack Compose를 활용한 Android 앱 확장.
2. **감정 분석 기능 추가**
   - 사용자가 작성한 내용을 분석하여 감정 색상을 추천.
3. **공유 기능**
   - 작성된 게시글을 이미지로 변환하여 SNS에 공유.
   - 

## 📧 **문의**

- **개발자:** 김은진, 김유진
- **이메일:** eunjin42767@example.com, youjin5587@gmail.com  
- **GitHub:** [https://github.com/Allogdallog-iOS/Allogdallog]

---

이 README 파일은 앱의 개요와 구현 내용을 명확히 전달하기 위해 작성되었습니다. 필요한 경우 내용을 수정하거나 보완하여 배포에 활용하세요! 😊
