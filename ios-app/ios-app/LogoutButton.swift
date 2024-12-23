//
//  LogoutButton.swift
//  ios-app
//
//  Created by Tabitha on 12/19/24.
//

import SwiftUI

struct LogoutButton: View {
    @Binding var userID: String?
    
    var body: some View {
        Button("Log Out") {
            self.userID = nil
        }
        .font(.title3)
    }
    
}

//#Preview {
//    LogoutButton()
//}
