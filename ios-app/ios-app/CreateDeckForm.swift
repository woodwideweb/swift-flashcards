//
//  CreateCategoryForm.swift
//  ios-app
//
//  Created by Tabitha on 3/13/25.
//

import SwiftUI
import Models
import NonEmpty

struct CreateDeckForm: View {
  @State private var name: String = ""
  @State private var showError: Bool = false
  @Binding var showCreateDeck: Bool
  var userId: UUID
  var onNewDeck: (Deck) -> Void

  var body: some View {
    Text("Create a deck")
      .font(.title2)
    
    Form {
      TextField(text: $name, prompt: Text("Name")) {
        Text("Name")
      }
      
      Button("Create") {
        Task {
          let cardResult = await post(
            to: .api(path: "/decks"),
            body: CreateDeckInput(name: name),
            decodeTo: Deck.self,
            userId: userId
          )
          switch cardResult {
          case .success(let deck):
            onNewDeck(deck)
            showError = false
            name = ""
          case .failure:
            showError = true
          }
        }
      }
      .disabled(name.isEmpty)
      
      
    }
    
    Button("Back to cards") {
      showCreateDeck = false
    }
    .alert("Something went wrong", isPresented: $showError) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Please try again.")
    }
  }
}

#Preview {
  CreateDeckForm(showCreateDeck: .constant(true), userId: UUID()) {_ in }
}
