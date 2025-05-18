//
//  NewUserAttachmentImageInfoDTO.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 18.05.2025.
//

import Foundation

struct NewUserAttachmentImageInfoDTO: Codable {
  let file: Data
  let name: String
  let fileName: String
  let mimeType: String
}
