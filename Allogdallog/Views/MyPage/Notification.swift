//
//  Notification.swift
//  Allogdallog
//
//  Created by 김유진 on 9/20/24.
//

import SwiftUI

struct Notification: View {
    var body: some View {
        VStack {
            HStack {
                Text("알림")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            }
            Divider()
            
            Spacer()
        }
    }
}

#Preview {
    Notification()
}
