//
//  NewUserDTO.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 18.05.2025.
//

struct NewUserDTO: Codable {
  let name, email, phone: String
  let position_id: Int
  let photo: NewUserAttachmentImageInfoDTO
  
  init?(name: String, email: String, phone: String, position_id: Int?, photo: NewUserAttachmentImageInfoDTO?) {
    self.name = name
    self.email = email
    self.phone = phone
    
    guard let position_id else { return nil }
    self.position_id = position_id
    
    guard let photo else { return nil }
    self.photo = photo
  }
}
