//
//  LogoutButton.swift
//  ios-app
//
//  Created by Tabitha on 12/19/24.
//

import SwiftUI

struct LogoutButton: View {
  @AppStorage(.userIdKey) private var userId: UUID?

  var body: some View {
    Button("Log Out") {
      userId = nil
    }
    .font(.title3)
  }
}
