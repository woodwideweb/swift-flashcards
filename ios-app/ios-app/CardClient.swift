//
//  CardClient.swift
//  ios-app
//
//  Created by Tabitha on 10/3/24.
//

import Foundation

class CardClient {

    var cards: [Card] {
        get async throws {
            let data = try await downloader.httpData(from: feedURL)
            let allCards = try decoder.decode(CardJson.self, from: data)
            return allCards
        }
    }

    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()


    private let feedURL = URL(string: "http://127.0.0.1:8080/cards")!


    private let downloader: any HTTPDataDownloader


    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }
}

struct Card: Codable {
  var question: String
  var answer: String
}

typealias CardJson = [Card]
