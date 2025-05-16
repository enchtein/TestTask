//
//  AppColor.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

enum AppColor {
  static let primary = Color(.primaryC)
  static let secondary = Color(.secondaryC)
  static let background = Color(.backgroundC)
  
  static let mainText = Color(.mainText)
  static let additionalText = Color(.additionalText)
  static let placeholderText = Color(.placeholderColorText)
  
  enum MainView {
    static let tabViewBg = Color(.tabViewBg)
    static let selectedTabTint = secondary
    static let unSelectedTabTint = additionalText
  }
  
  enum CommonButton {
    static let bg = primary
    static let inactiveBg = Color(.inactiveBg)
    
    static let text = mainText
    static let inactiveText = placeholderText
  }
  
  enum NoInternetView {
    static let bg = background
    static let text = mainText
  }
  
  enum UsersView {
    static let dividerColor = placeholderText
    static let baseText = mainText
    static let secondaryText = additionalText
  }
}
