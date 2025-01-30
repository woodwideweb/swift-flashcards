import Models
import Vapor

extension Parameters {
  func requireUUID(_ key: String) throws -> UUID {
    guard let idString = get(key) else {
      throw Abort(.unauthorized)
    }
    guard let uuid = UUID(uuidString: idString) else {
      throw Abort(.unauthorized)
    }
    return uuid
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

  app.get("cards", ":id") { req in
    let id = try req.parameters.requireUUID("id")

    let userRows = try await client.query(
      raw: "SELECT * FROM users WHERE id = \(bind: id)",
      decodeTo: User.self
    )

    guard userRows.count == 1 else {
      throw Abort(.unauthorized)
    }
    let user = userRows[0]

    return try await client.query(
      raw: "SELECT front AS question, back AS answer FROM cards WHERE user_id = \(bind: user.id)",
      decodeTo: Card.self
    )
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
        INSERT INTO cards (id, front, back, created_at, user_id)
        VALUES (\(bind: UUID()), \(bind: input.front), \(bind: input.back), NOW(), \(
          bind: input
            .userId
      ))
      """)
    } catch {
      print(String(reflecting: error))
      throw Abort(.badRequest)
    }

    let cardJson = try JSONEncoder().encode(Card(question: input.front, answer: input.back))
    return Response(status: .created, body: Response.Body(data: cardJson))
  }
}

extension User: Content {}
extension Card: Content {}
extension LoginInput: Content {}

struct CreateCardInput: Content {
  var front: String
  var back: String
  var userId: UUID
}
