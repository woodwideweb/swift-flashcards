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
