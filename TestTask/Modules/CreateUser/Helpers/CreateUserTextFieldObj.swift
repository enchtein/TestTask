//
//  CreateUserTextFieldObj.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI
import Combine

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


class CreateUserTextFieldObj: CreateUserFieldObj {
  @Published var isFocused: Bool = false
  @Published var text: String = ""
}
//MARK: - Mock's
extension CreateUserTextFieldObj {
  static let mock = CreateUserTextFieldObj(type: .name)
}

class CreateUserPhoneObject: CreateUserFieldObj {
  private var cancellables: Set<AnyCancellable> = []
  @Published var selectedImage: UIImage?
  @Published var selectedImageName: String?
  
  override init(type: CreateUserFieldType) {
    super.init(type: type)
    
    subscribeForChanges()
  }
  
  private func subscribeForChanges() {
    $selectedImage
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateSelectedImageName()
      }
      .store(in: &cancellables)
  }
  
  private func updateSelectedImageName() {
    let newText = selectedImage == nil ? nil : "Image selected"
    
    guard selectedImageName != newText else { return }
    selectedImageName = newText
    isErrored = newText == nil
  }
}
//MARK: - Mock's
extension CreateUserPhoneObject {
  static let mock = CreateUserPhoneObject(type: .avatar)
}



enum CreateUserFieldType: Int, CaseIterable {
  case name = 0
  case email
  case phone
  case avatar
  
  var hintText: String? {
    switch self {
    case .name: nil
    case .email: "Email"
    case .phone: nil
    case .avatar: nil
    }
  }
  var placeholderText: String {
    switch self {
    case .name: "Your name"
    case .email: "Email"
    case .phone: "Phone"
    case .avatar: "Upload your photo"
    }
  }
  
  var errorMsg: String {
    switch self {
    case .name: "Name shouldn't contains numbers or symbols"
    case .email: "Invalid email format"
    case .phone: "Invalid phone format"
    case .avatar: ""
    }
  }
  var emptyValueErrorMsg: String {
    switch self {
    case .name: "Required field"
    case .email: "Email is required"
    case .phone: "Required field"
    case .avatar: "Photo is required"
    }
  }
  
  var maskText: String {
    switch self {
    case .name: ""
    case .email: ""
    case .phone: "+38 (XXX) XXX - XX - XX"
    case .avatar: ""
    }
  }
  
  var kbType: UIKeyboardType {
    switch self {
    case .name:
        .default
    case .email:
        .emailAddress
    case .phone:
        .numberPad
    case .avatar: .default
    }
  }
}
