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
            Task {
              logout()
            }
        }
        .font(.title3)
    }
    
    func logout() -> Void {
        self.userID = nil
    }
}

//#Preview {
//    LogoutButton()
//}

//func logout() -> Void {
//    UserDefaults.standard.removeObject(forKey: .userIdKey)
//}

