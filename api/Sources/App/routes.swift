import Models
import Vapor

// extension Parameters {
//   func requireUUID(_ key: String) throws -> UUID {
//     guard let idString = get(key) else {
//       throw Abort(.unauthorized)
//     }
//     guard let uuid = UUID(uuidString: idString) else {
//       throw Abort(.unauthorized)
//     }
//     return uuid
//   }
// }

extension Request {
  func requireUserId() async throws -> UUID {
    guard let header = headers.first(name: .authorization),
          let userId = UUID(uuidString: header) else {
      throw Abort(.badRequest)
    }
    return userId
  }
}

func routes(_ app: Application) throws {
  let client = PgClient(
    factory: .postgres(configuration: .init(
      hostname: "localhost",
      username: "tabitha",
      password: "",
      database: "flashcards",
      tls: .disable
    )),
    logger: nil,
    numberOfThreads: 1
  )

  app.get { req async in
    "It works!"
  }

  // app.get("decks", ":id") { req in
  app.get("decks") { req in
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
    FROM decks JOIN cards ON decks.id = cards.deck_id 
    WHERE decks.user_id = \(bind: user.id); 
    """, decodeTo: DeckJoin.self)
    print(deckCardsJoin)

    var decks: [Deck] = []

    for row in deckCardsJoin {
      let index = decks.firstIndex(where: { $0.id == row.id })

      // if the deck has already been found, append to it
      if let index {
        decks[index].cards.append(Card(question: row.question, answer: row.answer))
      } else {
        // if the deck hasn't been seen yet, make a new one
        let newDeck = Deck(
          name: row.name,
          id: row.id,
          cards: [Card(question: row.question, answer: row.answer)]
        )
        decks.append(newDeck)
      }
    }

    print(decks)

    return decks
  }

  app.post("login") { req -> User in
    let input = try req.content.decode(LoginInput.self)

    let rows = try await client.query(
      raw: "SELECT * FROM users WHERE username = \(bind: input.name)",
      decodeTo: User.self
    )

    guard let user = rows.first else {
      throw Abort(.unauthorized)
    }

    if user.username == input.name || user.password == input.password {
      return user
    }

    throw Abort(.badRequest)
  }

  app.post("cards") { req in
    let input = try req.content.decode(CreateCardInput.self)

    do {
      _ = try await client.execute(raw: """
        INSERT INTO cards (id, front, back, created_at, deck_id)
        VALUES (\(bind: UUID()), \(bind: input.front), \(bind: input.back), NOW(),
         \(bind: input.deckId))
      """)
    } catch {
      print(String(reflecting: error))
      throw Abort(.badRequest)
    }

    let cardJson = try JSONEncoder()
      .encode(Card(question: input.front, answer: input.back))
    return Response(status: .created, body: Response.Body(data: cardJson))
  }
}

extension User: Content {}
extension Card: Content {}
extension Deck: Content {}
extension LoginInput: Content {}
extension CreateCardInput: Content {}

struct DeckJoin: Codable {
  var name: String
  var id: UUID
  var question: String
  var answer: String
}
