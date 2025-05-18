//
//  NewUserAttachmentImageInfo.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 18.05.2025.
//

import UIKit

struct NewUserAttachmentImageInfo {
  let image: UIImage
  let fileName: String
  let mimeType: String
  
  var toDTO: NewUserAttachmentImageInfoDTO? {
    guard let imgData = image.jpegData(compressionQuality: 0.5) else { return nil }
    return NewUserAttachmentImageInfoDTO(file: imgData, name: "photo", fileName: fileName, mimeType: mimeType)
  }
  
  init(image: UIImage, fileURL: URL?) {
    self.image = image
    self.fileName = fileURL?.lastPathComponent ?? "camera.jpg"
    self.mimeType = fileURL?.pathExtension ?? ".jpg"
  }
}
