import Models
import Vapor

struct AuthenticationRoutes: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.post("login", use: login)
  }

  func login(req: Request) async throws -> User {
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
}
