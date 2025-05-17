//
//  CreateUserTextFieldObj.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI

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





enum CreateUserFieldType: Int, CaseIterable {
  case name = 0
  case email
  case phone
  
  var hintText: String? {
    switch self {
    case .name: nil
    case .email: "Email"
    case .phone: nil
    }
  }
  var placeholderText: String {
    switch self {
    case .name: "Your name"
    case .email: "Email"
    case .phone: "Phone"
    }
  }
  
  var errorMsg: String {
    switch self {
    case .name: "Name shouldn't contains numbers or symbols"
    case .email: "Invalid email format"
    case .phone: "Invalid phone format"
    }
  }
  var emptyValueErrorMsg: String {
    switch self {
    case .name: "Required field"
    case .email: "Email is required"
    case .phone: "Required field"
    }
  }
  
  var maskText: String {
    switch self {
    case .name: ""
    case .email: ""
    case .phone: "+38 (XXX) XXX - XX - XX"
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
    }
  }
}
