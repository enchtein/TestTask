//
//  AppView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

enum AppView {
  case main
  case noInternet(error: Error, _ action: () -> Void)
  case createUserResult(responce: NewUserResponse, _ action: () -> Void)
}

extension AppView: Identifiable {
  public var id: Self { self }
}

extension AppView: Equatable {
  public static func == (lhs: AppView, rhs: AppView) -> Bool {
    return true
  }
}

extension AppView: Hashable {
  public func hash(into hasher: inout Hasher) {
    return hasher.combine(id)
  }
}
