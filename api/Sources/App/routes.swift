import Models
import Vapor

func routes(_ app: Application) throws {
  app.get { req async in
    "It works!"
  }

  app.get("cards") { req -> String in
    let encoder = JSONEncoder()
    let json = try encoder.encode(cards)
    return String(data: json, encoding: .utf8)!
  }

  app.post("login") { req in
    let userJson = try req.content.decode(UserJson.self)
    let user = users[0]
    print(userJson)
    print(user)
    if userJson.name == user.username || userJson.password == user.password {
      return user
    }

    throw Abort(.badRequest)
  }

  app.get("hello") { req async -> String in
    "Hello, world!"
  }

  app.get("hello", ":name") { req -> String in
    let name = req.parameters.get("name")!
    print(app.routes.all)
    return "Hello, \(name)!"
  }

  app.get("foo", "bar", "baz") { req in
    "something"
  }
}

struct UserJson: Content {
  var name: String
  var password: String
}

extension User: Content {}

let cards = [Card(question: "hola", answer: "hello"), Card(question: "adios", answer: "goodbye")]

let users = [User(username: "bob", password: "hello123", id: UUID().uuidString)]
