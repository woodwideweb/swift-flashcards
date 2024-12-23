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
  @State var showBack: Bool = false

  var body: some View {
    HStack {
      Spacer()
      Text(showBack ? back : front)
        .font(.title)
      Spacer()
    }
    .padding(.vertical, 110)
    .padding(.horizontal, 10)
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
  CardDisplay(front: "hola", back: "hello")
}
