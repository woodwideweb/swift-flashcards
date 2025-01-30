//
//  ContentView.swift
//  ios-app
//
//  Created by Tabitha on 9/26/24.
//

import Foundation
import Models
import SwiftUI

enum ViewState: Equatable {
  case loading
  case loaded([Card])
  case failed
}

extension String {
  static let userIdKey = "UserID"
}

struct ContentView: View {
  @State var state: ViewState = .loading
  @State private var showCreateCard = false
  @AppStorage(.userIdKey) private var userID: UUID?

  var body: some View {

    if userID != nil {
      VStack {
        if showCreateCard == false {
          CardLogic(userID: $userID, state: $state)
          LogoutButton(userID: $userID)
          Button("New Card") {
            showCreateCard = true
          }
          .font(.title3)
        } else {
          CreateCardForm(showCreateCard: $showCreateCard, userId: userID!) { card in
            if case .loaded(var cards) = state {
              cards.append(card)
              print("added card")
              state = .loaded(cards)
            }
          }
        }
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
    uuidString
  }

  public typealias RawValue = String

  public init?(rawValue: RawValue) {
    self.init(uuidString: rawValue)
  }
}
