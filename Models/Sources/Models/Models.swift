// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

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
  public var id: UUID

  public init(username: String, password: String, id: UUID) {
    self.username = username
    self.password = password
    self.id = id
  }
}

// rename to LoginInput
public struct LoginInput: Codable {
  public var name: String
  public var password: String

  public init(name: String, password: String) {
    self.name = name
    self.password = password
  }
}
