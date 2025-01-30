//
//  CreateCardForm.swift
//  ios-app
//
//  Created by Tabitha on 1/16/25.
//

import Models
import SwiftUI

struct CreateCardForm: View {
  @State private var front: String = ""
  @State private var back: String = ""
  @State private var showError: Bool = false
  @Binding var showCreateCard: Bool
  var userId: UUID
  var onNewCard: (Card) -> Void

  var body: some View {
    Text("Create a card")
      .font(.title2)
    
    Form {
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
            body: CreateCardInput(front: front, back: back, userId: userId),
            decodeTo: Card.self
          )
          switch cardResult {
          case .success(let card):
            onNewCard(card)
            showError = false
            front = ""
            back = ""
          case .failure:
            showError = true
          }
        }
      }
      
      
    }
    
    Button("Back to cards") {
      showCreateCard = false
    }
    .alert("Something went wrong", isPresented: $showError) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Please try again.")
    }
  }
}

#Preview {
  CreateCardForm(
    showCreateCard: .constant(true),
    userId: UUID(uuidString: "9d307d61-246e-48c2-8b77-a67154b586f6")!
  ) { _ in }
}
