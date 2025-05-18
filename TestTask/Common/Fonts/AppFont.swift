//
//  AppFont.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

enum FontType {
  case regular
  case semibold
  
  fileprivate var fullName: String {
    title + "-" + value
  }
  private var title: String {
    "NunitoSans10pt"
  }
  private var value: String {
    switch self {
    case .regular:
      "Regular"
    case .semibold:
      "SemiBold"
    }
  }
}

struct AppFont {
  static func font(_ type: FontType = .regular, size: CGFloat = 16.0) -> Font {
    return .custom(type.fullName, size: size)
  }
}
