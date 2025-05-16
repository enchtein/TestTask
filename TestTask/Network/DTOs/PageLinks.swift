//
//  PageLinks.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

struct PageLinks: Codable {
  let nextURL, prevURL: String?
}

//MARK: - CodingKeys
private extension PageLinks {
  enum CodingKeys: String, CodingKey {
    case nextURL = "next_url"
    case prevURL = "prev_url"
  }
}
