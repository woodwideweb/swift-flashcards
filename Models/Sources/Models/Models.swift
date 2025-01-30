// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public struct Card: Codable, Equatable {
  public var question: String
  public var answer: String

  public init(question: String, answer: String) {
    self.question = question
    self.answer = answer
  }
}

public struct User: Codable, Equatable {
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
public struct LoginInput: Codable, Equatable {
  public var name: String
  public var password: String

  public init(name: String, password: String) {
    self.name = name
    self.password = password
  }
}
