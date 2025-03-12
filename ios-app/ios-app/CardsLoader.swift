//
//  CardLogic.swift
//  ios-app
//
//  Created by Tabitha on 12/23/24.
//
// Loads decks and controls whether the state shown is loading, failure, or loaded. Makes API calls

import Models
import SwiftUI
import NonEmpty

enum ViewState: Equatable {
  case loading
  case loaded(NonEmpty<[Deck]>)
  case failed
}

struct CardsLoader: View {
  @AppStorage(.userIdKey) private var userId: UUID?
  @State var state: ViewState = .loading
  @State var currentDeck: UUID?
  @State var showCreateCard = false

  var body: some View {
    if userId != nil {
      VStack {
        switch self.state {
        case .loading:
          ProgressView()
        case .failed:
          Text("Something went wrong. No cards to display")
          
        case .loaded(var decks):
          // we need typesafety
          if !decks.isEmpty {
            if !showCreateCard {
              ContentView(decks: decks, userId: userId!, showCreateCard: $showCreateCard) { deckIndex in
                var cards = decks[deckIndex].cards
                cards.shuffle()
                decks[deckIndex].cards = cards
                state = .loaded(decks)
              }
            } else {
              CreateCardForm(showCreateCard: $showCreateCard, userId: userId!, decks: decks) {card, id in
                var deck = decks.first(where: { $0.id == id })!
                let index = decks.firstIndex(where: { $0.id == id })!
                deck.cards.append(card)
                decks[index] = deck
                state = .loaded(decks)
              }
            }
          } else {
            Text("no decks")
          }
        }
      }
      .padding()
      .task {
        if state == .loading {
          try? await self.getCards(id: userId!)
        }
      }
    } else {
      LoginFormContainer(userId: $userId)
    }
  }

  func getCards(id: UUID) async throws {
//    print("go get the cards")
    let deckResult = await getDataResult([Deck].self, url: URL.api(path: "/decks/\(id)"))
    switch deckResult {
    case .success([]):
      // change this...
      state = .failed
    case .success(var decks):
      // fix this
      state = .loaded(.init(decks)!)
    case .failure:
      state = .failed
    }
  }
}

#Preview {
  CardsLoader(
  )
}
