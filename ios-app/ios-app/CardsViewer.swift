//
//  CardViewer.swift
//  ios-app
//
//  Created by Tabitha on 1/9/25.
//
// UI for toggling between cards - does not make any API calls

import Models
import SwiftUI

struct CardsViewer: View {
  @State var index = 0
  var cards: [Card]

  var current: Card? {
    if !cards.isEmpty {
      return cards[index]
    }
    return nil
  }

  var body: some View {
    if let current {
      VStack {
        CardDisplay(front: current.question, back: current.answer, deck: "")
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
        .frame(width:100, height: 80)
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
    } else {
      Text("There are no cards in this deck yet")
    }
  }
}

#Preview {
  CardsViewer(cards: [
    Card(question: "hello", answer: "hola"),
    Card(question: "goodbye", answer: "adios"),
    Card(question: "gracias", answer: "thank you"),
  ])
}
