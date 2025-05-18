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
