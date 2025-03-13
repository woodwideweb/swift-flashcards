//
//  ContentView.swift
//  ios-app
//
//  Created by Tabitha on 9/26/24.
//

import Foundation
import Models
import NonEmpty
import SwiftUI

extension String {
  static let userIdKey = "UserID"
}

struct CardsLoader: View {

  var decks: NonEmpty<[Deck]>
  @State var currentDeckIndex: Int = 0
  var userId: UUID
  @Binding var showCreateCard: Bool
  @Binding var showCreateDeck: Bool
  var onShuffle: (Int) -> Void

  var currentDeck: Deck { decks[currentDeckIndex] }

  var body: some View {

    VStack {
      CardsViewer(cards: currentDeck.cards)

      LogoutButton {}

      Button("New Card") {
        showCreateCard = true
      }
      .font(.title3)

      Button("New Deck") {
        showCreateDeck = true
      }
      .font(.title3)

      Button("Shuffle cards") {
        onShuffle(currentDeckIndex)
      }
      .font(.title3)

      Picker("Deck", selection: $currentDeckIndex) {
        ForEach(Array(decks.enumerated()), id: \.offset) { index, deck in
          Text(deck.name).tag(index as Int?)
        }
      }
    }
  }
}

#Preview {
  CardsLoader(
    decks: [Deck(name: "something", id: UUID(), cards: [Card(question: "hola", answer: "hello")])],
    userId: UUID(),
    showCreateCard: .constant(false),
    showCreateDeck: .constant(false)
  ) { _ in }
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
