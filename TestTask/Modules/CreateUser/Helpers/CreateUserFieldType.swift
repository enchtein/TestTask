//
//  CreateUserFieldType.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 18.05.2025.
//

import SwiftUI

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
  var autocapitalizationType: TextInputAutocapitalization {
    switch self {
    case .name: .sentences
    default: .never
    }
  }
}
