//
//  NewUserResponse.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 18.05.2025.
//

struct NewUserResponse: Codable {
  let success: Bool
  let user_id: Int?
  let message: String
  let fails: [String: [String]]?
}

//MARK: - Mock
extension NewUserResponse {
  static let mockSuccess = NewUserResponse.init(success: true, user_id: 26187, message: "New user successfully registered", fails: nil)
}
