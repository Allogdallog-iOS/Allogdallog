//
//  DeleteAccount.swift
//  Allogdallog
//
//  Created by 김유진 on 10/21/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DeleteAccount: View {
    
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var password = "" // 사용자가 입력할 비밀번호
    @State private var isDeleted = false // 첫 화면으로 이동하는 상태
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if isProcessing {
                ProgressView("처리 중...")
                    .padding(.top, 60)
            } else {
                
                HStack {
                    Text("회원 탈퇴")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 5)
                    
                    Spacer()
                    
                    Button(action: {
                        if password.isEmpty {
                                alertMessage = "비밀번호를 입력해주세요."
                                showAlert = true
                        } else {
                            verifyPasswordAndDeleteAccount()
                                }
                    }) {
                        Text("탈퇴")
                            .font(.title3)
                            //.foregroundStyle(.gray)
                            .padding(.horizontal, 15)
                            .padding(.bottom, 5)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("알림"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                Divider()
                
                HStack{
                    Text("비밀번호 확인")
                        .padding(.leading)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.top, 15)
                    
                    Spacer()
                }
                
                SecureField("비밀번호를 입력하세요", text: $password)
                    .customTextFieldStyle(height: 50)
                    .padding(.top,5)
                    .padding(.horizontal, 20)
                
                // 탈퇴 후 첫 화면으로 이동
                    NavigationLink(destination: ContentView(), isActive: $isDeleted) {
                    EmptyView() // 버튼을 감추고 자동으로 이동할 수 있게 함
                }
            }
        }
        //.padding()
        Spacer()
    }
    
    // 현재 로그인한 사용자의 계정을 Firebase에서 삭제
        private func verifyPasswordAndDeleteAccount() {
            guard let user = Auth.auth().currentUser else {
                alertMessage = "로그인 되지 않은 계정입니다."
                showAlert = true
                return
            }
            
            isProcessing = true
            
            // 사용자의 이메일을 통해 재인증을 시도
            guard let email = user.email else {
                alertMessage = "이메일 정보를 가져올 수 없습니다."
                isProcessing = false
                showAlert = true
                return
            }
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            // 재인증 시도
            user.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    alertMessage = "비밀번호가 올바르지 않습니다."
                    isProcessing = false
                    showAlert = true
                    return
                }
                // 비밀번호 확인 성공, 계정 삭제 진행
                deleteUserAccount()
            }
        }
    
    //현재 로그인한 사용자의 계정을 Firebase에서 삭제
    private func deleteUserAccount() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "로그인 되지 않은 계정입니다."
            showAlert = true
            return
        }
        
        isProcessing = true
        
        // Firestore에서 사용자의 데이터 삭제
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(user.uid)
        
        userDocRef.delete { error in
            if let error = error {
                // Firestore에서 데이터 삭제 실패 시 처리
                alertMessage = "Failed to delete user data: \(error.localizedDescription)"
                isProcessing = false
                showAlert = true
                return
            }
            // receivedRequests와 sentRequests 문서 삭제
            deleteFriendRequests(for: user.uid) { requestError in
                if let requestError = requestError {
                    alertMessage = "Failed to delete friend requests: \(requestError.localizedDescription)"
                    isProcessing = false
                    showAlert = true
                    return
                }
                // 다른 유저들의 데이터에서 탈퇴한 유저의 기록 삭제
                deleteRelatedUserData(for: user.uid) { relatedError in
                    if let relatedError = relatedError {
                        alertMessage = "Failed to update related user data: \(relatedError.localizedDescription)"
                        isProcessing = false
                        showAlert = true
                        return
                    }
                    
                    user.delete { error in
                        if let error = error {
                            // 회원 탈퇴가 실패하면 에러 처리
                            if let errCode = AuthErrorCode(rawValue: error._code), errCode == .requiresRecentLogin {
                                // 최근 로그인하지 않은 경우, 재인증이 필요할 수 있음
                                alertMessage = "You need to re-login before deleting the account."
                                
                            } else {
                                alertMessage = "Account deletion failed: \(error.localizedDescription)"
                                isProcessing = false
                                showAlert = true
                            }
                        } else {
                            // 회원 탈퇴 성공
                            alertMessage = "계정이 탈퇴되었습니다."
                            // 추가적으로 데이터베이스에서 사용자의 데이터를 삭제하는 로직을 여기에 추가할 수 있습니다.
                            isProcessing = false
                            showAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isDeleted = true // 첫 화면으로 이동
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    // receivedRequests 및 sentRequests 삭제
    private func deleteFriendRequests(for userId: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        // 탈퇴한 사용자를 친구 목록에서 삭제
        db.collection("users").whereField("friends", arrayContains: userId).getDocuments { querySnapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No users found with the given friend ID: \(userId)")
                    completion(nil) // 친구가 없으면 종료
                    return
                }
                
                // 친구 목록에서 탈퇴한 사용자 제거
                documents.forEach { document in
                    let docRef = document.reference
                    batch.updateData(["friends": FieldValue.arrayRemove([userId])], forDocument: docRef)
                }
            
            // 탈퇴한 사용자가 보낸 친구 요청 처리 (수락되지 않은 요청)
            db.collection("friendRequest").whereField("fromUserId", isEqualTo: userId).getDocuments { querySnapshot, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                       print("No sent requests found for the user.")
                       completion(nil)
                       return
                   }
                   
                   // 친구 요청 삭제
                   documents.forEach { document in
                       batch.deleteDocument(document.reference)
                   }
                
                // 탈퇴한 사용자가 받은 친구 요청 처리 (수락되지 않은 요청)
                db.collection("friendRequest").whereField("toUserId", isEqualTo: userId).getDocuments { querySnapshot, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    querySnapshot?.documents.forEach { document in
                        batch.deleteDocument(document.reference)
                    }
                    
                    // 추가: users 컬렉션에서 receivedRequests 및 sentRequests 업데이트
                    db.collection("users").document(userId).getDocument { documentSnapshot, error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        
                        guard let document = documentSnapshot, document.exists else {
                            completion(nil)
                            return
                        }
                        
                        // receivedRequests에서 친구 요청 ID들 제거
                        batch.updateData([
                            "receivedRequests": FieldValue.arrayRemove([userId]),
                            "sentRequests": FieldValue.arrayRemove([userId])
                        ], forDocument: document.reference)
                        
                        
                        // 변경 사항 커밋
                        batch.commit { batchError in
                            completion(batchError)
                        }
                    }
                }
            }
        }
    }
        // 관련된 사용자 데이터 삭제
    private func deleteRelatedUserData(for userId: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        // 친구 목록에서 해당 사용자를 제거
        db.collection("users").whereField("friends", arrayContains: userId).getDocuments { querySnapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            querySnapshot?.documents.forEach { document in
                let docRef = document.reference
                batch.updateData(["friends": FieldValue.arrayRemove([userId])], forDocument: docRef)
            }
            
            // 탈퇴한 사용자의 모든 친구 요청 삭제 (양방향)
            db.collection("friendRequest").whereField("fromUserId", isEqualTo: userId).getDocuments { querySnapshot, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                querySnapshot?.documents.forEach { document in
                    batch.deleteDocument(document.reference)
                }
                
                //탈퇴한 사용자가 받은 모든 친구 요청 삭제
                db.collection("friendRequest").whereField("toUserId", isEqualTo: userId).getDocuments { querySnapshot, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    querySnapshot?.documents.forEach { document in
                        batch.deleteDocument(document.reference)
                    }
                    // 배치 커밋
                    batch.commit { batchError in
                        if let batchError = batchError {
                        completion(batchError)
                        } else {
                            completion(nil) // 성공적으로 삭제됨
                                            }
                    }
                }
            }
        }
    }
    
    // 사용자 재인증을 위한 함수
    private func reauthenticateUser(_ user: FirebaseAuth.User) {
          // 사용자의 현재 인증 방식에 따라 재인증 처리
          
          guard let email = user.email else {
                     alertMessage = "이메일 정보를 가져올 수 없습니다."
                     isProcessing = false
                     showAlert = true
                     return
                 }
          
          let credential = EmailAuthProvider.credential(withEmail: email, password: password) // 실제로 비밀번호 입력 폼이 필요함
          
          user.reauthenticate(with: credential) { authResult, error in
              if let error = error {
                  alertMessage = "재인증에 실패했습니다: \(error.localizedDescription)"
              } else {
                  // 재인증 성공 후 계정 삭제 재시도
                  self.deleteUserAccount()
              }
              isProcessing = false
              showAlert = true
          }
      }
  }

       struct DeleteAccount_Previews: PreviewProvider {
           static var previews: some View {
               DeleteAccount()
           }
       }

