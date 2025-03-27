import Models
import Vapor

struct DeckRoutes: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.get("decks", use: getDecks)
    routes.post("decks", use: postDeck)
  }

  func getDecks(req: Request) async throws -> [Deck] {
    let id = try await req.requireUserId()

    let userRows = try await client.query(
      raw: "SELECT * FROM users WHERE id = \(bind: id)",
      decodeTo: User.self
    )

    guard userRows.count == 1 else {
      throw Abort(.unauthorized)
    }
    let user = userRows[0]

    let deckCardsJoin = try await client.query(raw: """
    SELECT name, decks.id AS id, cards.front AS question, cards.back AS answer
    FROM decks LEFT JOIN cards ON decks.id = cards.deck_id 
    WHERE decks.user_id = \(bind: user.id); 
    """, decodeTo: DeckJoin.self)

    var decks: [Deck] = []

    for row in deckCardsJoin {
      let index = decks.firstIndex(where: { $0.id == row.id })

      // if the deck has already been found, append to it
      if let index {
        if let question = row.question, let answer = row.answer {
          decks[index].cards.append(Card(question: question, answer: answer))
        }
      } else {
        // if the deck hasn't been seen yet, make a new one
        var newDeck = Deck(name: row.name, id: row.id, cards: [])
        if let question = row.question, let answer = row.answer {
          newDeck.cards.append(Card(question: question, answer: answer))
        }
        decks.append(newDeck)
      }
    }

    print(decks)

    return decks
  }

  // app.post("decks") { req in
  func postDeck(req: Request) async throws -> Response {
    let userId = try await req.requireUserId()
    let input = try req.content.decode(CreateDeckInput.self)
    let deckId = UUID()

    do {
      _ = try await client
        // make a db abstraction for insertion?
        .execute(
          raw: """
            INSERT INTO decks (id, name, created_at, user_id) 
            VALUES (\(bind: deckId), \(bind: input.name), NOW(), \(bind: userId))
          """
        )
    } catch {
      print(String(reflecting: error))
      throw Abort(.badRequest)
    }

    // do the same thing as in the cards posting...
    let deckJson = try JSONEncoder().encode(Deck(name: input.name, id: deckId, cards: []))
    return Response(status: .created, body: Response.Body(data: deckJson))
  }
}
