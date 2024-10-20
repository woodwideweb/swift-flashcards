//
//  ContentView.swift
//  ios-app
//
//  Created by Tabitha on 9/26/24.
//

import SwiftUI

enum ViewState {
    case loading
    case loaded([Card])
    case failed
}

struct ContentView: View {
    @State var state: ViewState = .loading
    var body: some View {
        VStack {
            switch self.state {
            case .loading:
                ProgressView()
            case .failed:
                Text("Something went wrong. No cards to display")
                
            case .loaded(let cards):
                Text("Welcome to Flashcards!")
                ForEach(cards, id: \.question) { card in
                    CardDisplay(front:card.question, back:card.answer)
                }
            }
        }
        .padding()
        .task {
            await self.getCards()
        }
    }
    
    func getCards() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL.api(path: "/cards"))
            let decoder = JSONDecoder()
            let cards = try decoder.decode([Card].self, from: data)
            self.state = .loaded(cards)
        } catch {
            self.state = .failed
        }
    }
}

#Preview {
    ContentView()
}

struct Card: Codable {
  var question: String
  var answer: String
}

extension URL {
    static func api(path: String) -> URL {
        return URL(string: "http://127.0.0.1:8080\(path)")!
    }
}
