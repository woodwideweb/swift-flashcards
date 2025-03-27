//
//  CreateCardForm.swift
//  ios-app
//
//  Created by Tabitha on 1/16/25.
//

import Models
import NonEmpty
import SwiftUI

struct CreateCardForm: View {
  @State private var front: String = ""
  @State private var back: String = ""
  @State private var showError: Bool = false
  @State private var deckSelection: UUID?
  @Binding var showCreateCard: Bool
  var userId: UUID
  var decks: NonEmpty<[Deck]>
  var onNewCard: (Card, UUID) -> Void

  var body: some View {
    Text("Create a card")
      .font(.title2)

    Form {
      Picker("Deck", selection: $deckSelection) {
        ForEach(decks, id: \.id) { deck in
          Text(deck.name).tag(deck.id as UUID?)
        }
      }

      TextField(text: $front, prompt: Text("Front")) {
        Text("Front")
      }

      TextField(text: $back, prompt: Text("Back")) {
        Text("Back")
      }

      Button("Create") {
        Task {
          let cardResult = await post(
            to: .api(path: "/cards"),
            body: CreateCardInput(front: front, back: back, deckId: deckSelection!),
            decodeTo: Card.self,
            userId: userId
          )
          switch cardResult {
          case .success(let card):
            onNewCard(card, deckSelection!)
            showError = false
            front = ""
            back = ""
          case .failure:
            showError = true
          }
        }
      }
      .disabled(front.isEmpty || back.isEmpty || deckSelection == nil)
    }

    Button("Back to cards") {
      showCreateCard = false
    }
    .alert("Something went wrong", isPresented: $showError) {
      Button("OK", role: .cancel) {}
    } message: {
      Text("Please try again.")
    }
  }
}

#Preview {
  CreateCardForm(
    showCreateCard: .constant(true),
    userId: UUID(uuidString: "9d307d61-246e-48c2-8b77-a67154b586f6")!,
    decks: [
      Deck(
        name: "Basic Phrases",
        id: UUID(uuidString: "309cda4f-0b49-4f09-a582-13ef46b5c1ea")!,
        cards: []
      ),
      Deck(
        name: "Something else",
        id: UUID(uuidString: "9f758889-8749-45d5-9795-87524831c9ed")!,
        cards: []
      ),
    ]
  ) { _, _ in }
}
