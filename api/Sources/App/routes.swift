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
  app.get { req async in
    "It works!"
  }

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

  app.get("cards", ":id") { req in
    let id = try req.parameters.requireUUID("id")

    let userRows = try await client
      .execute(raw: "SELECT * FROM users WHERE id = \(bind: id)")

    guard userRows.count == 1 else {
      throw Abort(.unauthorized)
    }

    let user = try userRows[0].decode(
      model: User.self,
      prefix: nil,
      keyDecodingStrategy: .convertFromSnakeCase
    )

    let rows = try await client
      .execute(
        raw: "SELECT front AS question, back AS answer FROM cards WHERE user_id = \(bind: user.id)"
      )
    return try rows.map { row in
      try row.decode(model: Card.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
    }
  }

  app.post("login") { req -> User in
    let input = try req.content.decode(UserJson.self)
    let rows = try await client
      .execute(raw: "SELECT * FROM users WHERE username = \(bind: input.name)")

    guard let row = rows.first else {
      throw Abort(.unauthorized)
    }

    let user = try row.decode(
      model: User.self,
      prefix: nil,
      keyDecodingStrategy: .convertFromSnakeCase
    )

    if user.username == input.name || user.password == input.password {
      return user
    }

    throw Abort(.badRequest)
  }
}

extension User: Content {}
extension Card: Content {}
extension UserJson: Content {}
