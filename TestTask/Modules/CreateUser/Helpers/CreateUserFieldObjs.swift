//
//  CreateUserFieldObjs.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI
import Combine

//MARK: - CreateUserFieldObj
class CreateUserFieldObj: ObservableObject {
  let type: CreateUserFieldType
  
  var isEmptyValue: Bool = true
  @Published var isErrored: Bool = false
  
  init(type: CreateUserFieldType) {
    self.type = type
  }
}
//MARK: - Mock's
extension CreateUserFieldObj {
  static let baseMock = CreateUserTextFieldObj(type: .phone)
}

//MARK: - CreateUserTextFieldObj
class CreateUserTextFieldObj: CreateUserFieldObj {
  @Published var isFocused: Bool = false
  @Published var text: String = ""
}
//MARK: - Mock's
extension CreateUserTextFieldObj {
  static let mock = CreateUserTextFieldObj(type: .name)
}

//MARK: - CreateUserPhoneObject
class CreateUserPhoneObject: CreateUserFieldObj {
  private var cancellables: Set<AnyCancellable> = []
  @Published var selectedImageInfo: NewUserAttachmentImageInfo?
  @Published var selectedImageName: String?
  
  override init(type: CreateUserFieldType) {
    super.init(type: type)
    
    subscribeForChanges()
  }
  
  private func subscribeForChanges() {
    $selectedImageInfo
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateSelectedImageName()
      }
      .store(in: &cancellables)
  }
  
  private func updateSelectedImageName() {
    let newText = selectedImageInfo == nil ? nil : "Image selected"
    
    guard selectedImageName != newText else { return }
    selectedImageName = newText
    isErrored = newText == nil
  }
}
//MARK: - Mock's
extension CreateUserPhoneObject {
  static let mock = CreateUserPhoneObject(type: .avatar)
}
