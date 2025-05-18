//
//  ImagePickerView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
  @Binding var image: NewUserAttachmentImageInfo?
  @State var imageAction: Bool = false
  @Environment(\.presentationMode) var presentationMode
  let selectedSourceType: UIImagePickerController.SourceType
  
  final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePickerView
    
    init(_ parent: ImagePickerView) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      if let selectedImage = info[.originalImage] as? UIImage {
        parent.image = NewUserAttachmentImageInfo(image: selectedImage, fileURL: info[.imageURL] as? URL)
      }
      parent.presentationMode.wrappedValue.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = selectedSourceType
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {}
}
