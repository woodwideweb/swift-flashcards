import Models
import Vapor

struct CardsRoutes: RouteCollection {
  func boot(routes: RoutesBuilder) {
    routes.post("cards", use: postCard)
  }

  func postCard(req: Request) async throws -> Response {
    try await req.requireUserId()
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

    let newCard = Card(question: input.front, answer: input.back)
    return try await newCard.encodeResponse(status: .created, for: req)
  }
}
