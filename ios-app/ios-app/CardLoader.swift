//
//  CardViewer.swift
//  ios-app
//
//  Created by Tabitha on 11/7/24.
//

import Models
import SwiftUI

struct CardLoader: View {

  var state: ViewState

  var body: some View {
    VStack {
      switch self.state {
      case .loading:
        ProgressView()
      case .failed:
        Text("Something went wrong. No cards to display")

      case .loaded(let cards):
        CardViewer(cards: cards)
      }
    }
  }
}
