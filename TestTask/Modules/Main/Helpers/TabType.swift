//
//  TabType.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

extension MainView {
  enum TabType: Int, CaseIterable, Identifiable {
    var id: Int { self.rawValue }
    
    case users = 0
    case singUp
    
    var image: Image {
      switch self {
      case .users:
        Image(systemName: "list.dash")
      case .singUp:
        Image(systemName: "list.dash")
      }
    }
    var title: Text {
      switch self {
      case .users:
        Text("Users")
      case .singUp:
        Text("Sign up")
      }
    }
  }
}
