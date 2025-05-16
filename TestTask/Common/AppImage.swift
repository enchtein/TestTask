//
//  AppImage.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

enum AppImage {
  enum LaunchScreen {
    static let logo = Image(.launchLogo)
    static let logoText = Image(.launchLogoText)
  }
  
  enum NoInternet {
    static let logo = Image(.noInternet)
  }
}

