//
//  CardLogic.swift
//  ios-app
//
//  Created by Tabitha on 12/23/24.
//

import Models
import SwiftUI

struct CardLogic: View {
  //  @State var state: ViewState = .loading
  @Binding var userID: UUID?
  @Binding var state: ViewState
  
  var body: some View {
    CardLoader(state: state)
      .padding()
      .task {
        if state == .loading {
          try? await self.getCards(id: userID!)
        }
      }
  }
  
  func getCards(id: UUID) async throws {
    print("go get the cards")
    let cardResult = await getDataResult([Card].self, url: URL.api(path: "/cards/\(id)"))
    switch cardResult {
    case .success(let cards):
      state = .loaded(cards)
    case .failure:
      state = .failed
    }
  }
}

#Preview {
  CardLogic(userID: .constant(UUID(uuidString: "9d307d61-246e-48c2-8b77-a67154b586f6")), state: .constant(.loading))
}
