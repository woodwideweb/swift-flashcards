// The Swift Programming Language
// https://docs.swift.org/swift-book
public struct Card: Codable {
  public var question: String
  public var answer: String

  public init(question: String, answer: String) {
    self.question = question
    self.answer = answer
  }
}

public struct User: Codable {
  public var username: String
  public var password: String
  public var id: String

  public init(username: String, password: String, id: String) {
    self.username = username
    self.password = password
    self.id = id
  }
}
