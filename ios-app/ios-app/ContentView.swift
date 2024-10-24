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
        let cardResult = await getDataResult([Card].self, url: URL.api(path: "/cards"))
        switch cardResult {
            case .success(let cards):
                self.state = .loaded(cards)
            case .failure:
                self.state = .failed
        }
//          do {
//            let cards = try await getData([Card].self, url: URL.api(path: "/cards"))
//            self.state = .loaded(cards)
//        } catch {
//            self.state = .failed
//        }
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

func getData<T: Codable>(_ t: T.Type, url: URL) async throws -> T {
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let decodedData = try decoder.decode(t, from: data)
    return decodedData
}

func getDataResult<T: Codable>(_ t: T.Type, url: URL) async -> Result<T, Error> {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(t, from: data)
        return .success(decodedData)
    } catch {
        return .failure(error)
    }
    
}

extension String: Error {}
