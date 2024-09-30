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

struct Card: Codable {
  var question: String
  var answer: String
}

let cards = [Card(question: "hola", answer: "hello"), Card(question: "adios", answer: "goodbye")]
