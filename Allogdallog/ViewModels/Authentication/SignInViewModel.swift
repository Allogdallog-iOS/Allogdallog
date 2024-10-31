//
//  SignInViewModel.swift
//  Allogdallog
//
//  Created by 믕진희 on 7/26/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var errorMessage: String? = nil
    
    private var db = Firestore.firestore()
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "아이디와 비밀번호를 확인해주세요."
                return
            }
            guard let authResult = authResult else {return}
            self?.user = User(id: authResult.user.uid, email: authResult.user.email ?? "")
            self?.isLoggedIn = true
            
            // Firestore에서 사용자 데이터 가져오기
            self?.fetchUserData(uid: authResult.user.uid)
            self?.listenForUserChanges(uid: authResult.user.uid) // 실시간 업데이트 리스너
        }
    }
    private func fetchUserData(uid: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
            db.collection("users").document(uid).getDocument { [weak self] document, error in
                guard let self = self, error == nil, let document = document, document.exists else {
                    self?.errorMessage = "사용자 정보를 가져오는 데 실패했습니다."
                    return
                }
                // Firestore에서 불러온 데이터를 Friend 객체로 변환
                        let friendsData = document.get("friends") as? [[String: Any]] ?? []
                        let friends = friendsData.compactMap { Friend(dictionary: $0) }
                        
                self.user?.friends = friends // friends 배열 업데이트
                
                // Firestore에서 사용자 정보를 업데이트
                self.user?.nickname = document.get("nickname") as? String ?? ""
                self.user?.profileImageUrl = document.get("profileImageUrl") as? String ?? ""
                // 필요한 다른 필드도 업데이트할 수 있습니다.
            }
        }
        
        // 사용자가 변경될 때마다 업데이트를 받을 수 있도록 리스너 추가
        func listenForUserChanges(uid: String) {
            db.collection("users").document(uid).addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                guard let document = documentSnapshot, document.exists else {
                    print("문서가 존재하지 않습니다.")
                    return
                }

                // 변경된 사용자 데이터 업데이트
                self.user?.nickname = document.get("nickname") as? String ?? ""
                self.user?.profileImageUrl = document.get("profileImageUrl") as? String ?? ""
                // 필요한 다른 필드도 업데이트할 수 있습니다.
            }
        }
    }
