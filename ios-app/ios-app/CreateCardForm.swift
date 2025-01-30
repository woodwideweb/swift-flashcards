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
          case .failure:
            print("oh no")
          }
        }
      }
    }
    
    Button("Back to cards") {
      showCreateCard = false
    }
  }
}

#Preview {
  CreateCardForm(
    showCreateCard: .constant(true),
    userId: UUID(uuidString: "9d307d61-246e-48c2-8b77-a67154b586f6")!
  ) {_ in }
}

struct CreateCardInput: Codable {
  var front: String
  var back: String
  var userId: UUID
}
