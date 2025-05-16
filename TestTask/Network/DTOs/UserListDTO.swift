//
//  UserListDTO.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

struct UserListDTO: Codable {
  let success: Bool
  let totalPages, totalUsers, count, page: Int
  let links: PageLinks
  let users: [User]
}

//MARK: - CodingKeys
private extension UserListDTO {
  enum CodingKeys: String, CodingKey {
    case success
    case totalPages = "total_pages"
    case totalUsers = "total_users"
    case count, page, links, users
  }
}
