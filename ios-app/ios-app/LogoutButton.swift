//
//  LogoutButton.swift
//  ios-app
//
//  Created by Tabitha on 12/19/24.
//

import SwiftUI

struct LogoutButton: View {
//  @Binding var userID: UUID?
  var onLogout: () -> Void

  var body: some View {
    Button("Log Out") {
      onLogout()
//      self.userID = nil
    }
    .font(.title3)
  }
}
