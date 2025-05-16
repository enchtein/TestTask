//
//  User.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

struct User: Codable, Equatable, Hashable {
  let id: Int
  let name, email, phone, position: String
  let positionID, registrationTimestamp: Int
  let photo: String
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  static func ==(lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }
}

//MARK: - Mock's
extension User {
  static var mock: User = User.init(id: 26148, name: "tero", email: "tero@gmail.com", phone: "+380456789876", position: "Content manager", positionID: 2, registrationTimestamp: 1747391828, photo: "https://frontend-test-assignment-api.abz.agency/images/users/68271554474cd26148.jpg")
}

//MARK: - CodingKeys
private extension User {
  enum CodingKeys: String, CodingKey {
    case id, name, email, phone, position
    case positionID = "position_id"
    case registrationTimestamp = "registration_timestamp"
    case photo
  }
}
