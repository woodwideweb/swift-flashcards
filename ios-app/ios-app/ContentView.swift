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
        CardViewer(state: state)
          .padding()
        LogoutButton(userID: $userID)
      }
      .task {
        try? await self.getCards(id: userID!)
      }
    } else {
      LoginFormContainer(userID: $userID)
    }
  }

  func getCards(id: UUID) async throws {
    let cardResult = await getDataResult([Card].self, url: URL.api(path: "/cards/\(id)"))
    switch cardResult {
    case .success(let cards):
      state = .loaded(cards)
    case .failure:
      state = .failed
    }
  }
}

#Preview {
  ContentView()
}

// this is something I got off StackOverflow to make an error go away
// I have no idea what it's doing or what this protocol is
extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}
