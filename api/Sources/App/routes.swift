import Models
import Vapor

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

  app.get("cards") { req in
    let rows = try await client.execute(raw: "SELECT front AS question, back AS answer FROM cards")
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

struct UserJson: Content {
  var name: String
  var password: String
}

extension User: Content {}
extension Card: Content {}

let cards = [Card(question: "hola", answer: "hello"), Card(question: "adios", answer: "goodbye")]

let users = [User(username: "bob", password: "hello123", id: UUID().uuidString)]

struct ThingsRow: Codable {
  let textField: String
  let id: UUID
  let createdAt: Date
}
