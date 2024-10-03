//
//  CardProvider.swift
//  ios-app
//
//  Created by Tabitha on 10/3/24.
//

import Foundation

class CardProvider: ObservableObject {


    @Published var cards: [Card] = []


    let client: CardClient


    func fetchCards() async throws {
        let newCards = try await client.cards
        self.cards = newCards
    }


    init(client: CardClient = CardClient()) {
        self.client = client
    }
}
