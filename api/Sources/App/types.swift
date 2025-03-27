import Models
import Vapor

// content conformances
extension User: Content {}
extension Card: Content {}
extension Deck: Content {}
extension LoginInput: Content {}
extension CreateCardInput: Content {}
extension CreateDeckInput: Content {}

// API-only types
struct DeckJoin: Codable {
  var name: String
  var id: UUID
  var question: String?
  var answer: String?
}
