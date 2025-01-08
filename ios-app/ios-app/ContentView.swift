//
//  ContentView.swift
//  ios-app
//
//  Created by Tabitha on 9/26/24.
//

import Models
import SwiftUI
import Foundation


enum ViewState {
  case loading
  case loaded([Card])
  case failed
}

extension String {
  static let userIdKey = "UserID"
}

struct ContentView: View {
  @State private var state: ViewState = .loading
  @AppStorage(.userIdKey) private var userID: UUID?

  var body: some View {

    if userID != nil {
      VStack {
        CardLogic(userID: $userID)
        LogoutButton(userID: $userID)
      }
    } else {
      LoginFormContainer(userID: $userID)
    }
  }
}


#Preview {
  ContentView()
}

extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}
