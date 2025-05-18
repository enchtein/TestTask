//
//  Position.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

struct Position: Codable, Equatable, Hashable {
  let id: Int
  let name: String
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  static func == (lhs: Position, rhs: Position) -> Bool {
    lhs.id == rhs.id
  }
}

//MARK: - Mock's
extension Position {
  static let mock = Position(id: 1, name: "Content manager")
}
