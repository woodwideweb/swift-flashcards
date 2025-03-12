//
//  CardDisplay.swift
//  ios-app
//
//  Created by Tabitha on 10/17/24.
//

import SwiftUI

struct CardDisplay: View {
  var front: String
  var back: String
  var deck: String
  @State var showBack: Bool = false

  var body: some View {
    VStack {
      HStack {
        Text(deck)
        Spacer()
      }
      .padding(.top)
      .padding(.leading)
      HStack {
        Text(showBack ? back : front)
          .font(.title)
          .padding(.bottom)
      }
      // I don't understand how to use Kiah's magic tricks...
      .frame(width: 100, height: 230)
    }
    .background(Color.offWhite.shadow(.drop(color: .black, radius: 20, y: 5)))
    .gesture(
      TapGesture()
        .onEnded { _ in
          showBack = !showBack
        }
    )
  }
}

#Preview {
  CardDisplay(front: "hola", back: "hello", deck: "Basic phrases")
}
