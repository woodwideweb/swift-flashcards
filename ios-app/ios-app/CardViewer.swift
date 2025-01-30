//
//  CardViewer.swift
//  ios-app
//
//  Created by Tabitha on 1/9/25.
//

import Models
import SwiftUI

struct CardViewer: View {
  @State var index = 0
  var cards: [Card]

  var current: Card {
    cards[index]
  }

  var body: some View {
    VStack {
      CardDisplay(front: current.question, back: current.answer)
        .padding(.bottom, 30)
        .padding(.top, 70)

      HStack {
        Button { index -= 1 }
                label: {
            Image(systemName: "arrow.left.circle")
              .resizable()
              .frame(width: 30, height: 30)
          }
          .disabled(index == 0)

        Button { index += 1 }
                    label: {
            Image(systemName: "arrow.right.circle")
              .resizable()
              .frame(width: 30, height: 30)
          }
          .disabled(index == cards.count - 1)
      }
    }
    .gesture(
      DragGesture()
        .onEnded { gesture in
          withAnimation {
            if gesture.translation.width > 50 {
              if index < cards.count - 1 {
                index += 1
              }
            } else if gesture.translation.width < -50 {
              if index > 0 {
                index -= 1
              }
            }
          }
        }
    )
  }
}

#Preview {
  CardViewer(cards: [
    Card(question: "hello", answer: "hola"),
    Card(question: "goodbye", answer: "adios"),
    Card(question: "gracias", answer: "thank you"),
  ])
}
