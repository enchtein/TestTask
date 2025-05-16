//
//  UserListFilter.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

struct UserListFilter: Codable {
  let page: Int
  let count: Int
  
  init(page: Int, count: Int) {
    self.page = page
    self.count = count
  }
}
