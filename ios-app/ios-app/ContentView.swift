//
//  CardLogic.swift
//  ios-app
//
//  Created by Tabitha on 12/23/24.
//
// Loads decks and controls whether the state shown is loading, failure, or loaded. Makes API calls

import Models
import NonEmpty
import SwiftUI

enum ViewState: Equatable {
  case loading
  case loaded(NonEmpty<[Deck]>)
  case empty
  case failed
}

struct ContentView: View {
  @AppStorage(.userIdKey) private var userId: UUID?
  @State var state: ViewState = .loading
  @State var currentDeck: UUID?
  @State var showCreateCard = false
  @State var showCreateDeck = false

  var body: some View {
    if let userId {
      VStack {
        switch self.state {
        case .loading:
          ProgressView()
        case .empty:
          Text("empty")
        case .failed:
          Text("Something went wrong. No cards to display")

        case .loaded(var decks):
          if !showCreateCard, !showCreateDeck {
            CardsLoader(
              decks: decks,
              userId: userId,
              showCreateCard: $showCreateCard,
              showCreateDeck: $showCreateDeck
            ) { deckIndex in
              var cards = decks[deckIndex].cards
              cards.shuffle()
              decks[deckIndex].cards = cards
              state = .loaded(decks)
            }
          } else if showCreateCard {
            CreateCardForm(
              showCreateCard: $showCreateCard,
              userId: userId,
              decks: decks
            ) { card, id in
              var deck = decks.first(where: { $0.id == id })!
              let index = decks.firstIndex(where: { $0.id == id })!
              deck.cards.append(card)
              decks[index] = deck
              state = .loaded(decks)
            }
          } else if showCreateDeck {
            CreateDeckForm(showCreateDeck: $showCreateDeck, userId: userId) { deck in
              decks.append(deck)
              state = .loaded(decks)
            }
          }
        }
      }
      .padding()
      .task {
        if state == .loading {
          try? await self.getCards(id: userId)
        }
      }
    } else {
      LoginFormContainer(userId: $userId)
    }
  }

  func getCards(id: UUID) async throws {
    let deckResult = await getDataResult([Deck].self, url: URL.api(path: "/decks"), userId: id)
    switch deckResult {
    case .success(var decks):
      if !decks.isEmpty {
        let head = decks.removeFirst()
        var nonEmptyDecks: NonEmpty<[Deck]> = .init(head)
        nonEmptyDecks.append(contentsOf: decks)
        state = .loaded(nonEmptyDecks)
      } else {
        state = .empty
      }
    case .failure:
      state = .failed
    }
  }
}

#Preview {
  ContentView()
}
