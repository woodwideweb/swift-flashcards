import Models
import Vapor

extension Request {
  @discardableResult func requireUserId() async throws -> UUID {
    guard let header = headers.first(name: .authorization),
          let userId = UUID(authorizationHeader: header) else {
      throw Abort(.badRequest)
    }
    return userId
  }
}

extension UUID {
  init?(authorizationHeader: String) {
    let splitHeader = authorizationHeader.split(separator: " ")
    if splitHeader.count == 2 && splitHeader[0] == "Bearer" {
      self.init(uuidString: String(splitHeader[1]))
    } else {
      return nil
    }
  }
}

func routes(_ app: Application) throws {
  try? app.register(collection: DeckRoutes())
  // we don't know that this one works
  try? app.register(collection: AuthenticationRoutes())
  try? app.register(collection: CardsRoutes())

  app.get { req async in
    "It works!"
  }

  // app.post("login") { req -> User in
  //   let input = try req.content.decode(LoginInput.self)

  //   let rows = try await client.query(
  //     raw: "SELECT * FROM users WHERE username = \(bind: input.name)",
  //     decodeTo: User.self
  //   )

  //   guard let user = rows.first else {
  //     throw Abort(.unauthorized)
  //   }

  //   if user.username == input.name || user.password == input.password {
  //     return user
  //   }

  //   throw Abort(.badRequest)
  // }
}

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
