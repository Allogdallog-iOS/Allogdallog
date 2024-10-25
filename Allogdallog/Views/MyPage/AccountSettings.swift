//
//  AccountSettings.swift
//  Allogdallog
//
//  Created by 김유진 on 10/25/24.
//

import SwiftUI

struct AccountSettings: View {
    var body: some View {
        VStack {
            HStack {
                Text("계정 관리")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            Divider()
            //임시 연결 수정 필요
            NavigationLink(destination: DeleteAccount()) {
                
                HStack{
                    Text("비밀번호 재설정")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                }
            }
                Divider()
            
            NavigationLink(destination: DeleteAccount()) {
                
                HStack{
                    
                    Text("회원 탈퇴")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                }
            }
            Divider()
        }
        
        Spacer()
    }
}
