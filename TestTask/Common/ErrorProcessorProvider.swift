//
//  ErrorProcessorProvider.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 24.05.2025.
//

import SwiftUI

final class ErrorProcessorProvider: ObservableObject {
  @ObservedObject private var router: Router
  
  static let shared = ErrorProcessorProvider(router: .default)
  
  private var outerError: Error?
  var error: Error {
    outerError ?? ErrorProcessing.noInterner
  }
  private var action: (() -> Void)?
  
  private init(router: MainRouter) {
    self.router = router
  }
}

//MARK: - API
extension ErrorProcessorProvider {
  func presentError(from router: Router, with error: Error, action: (() -> Void)? = nil) {
    resetParams()
    
    self.router = router
    
    outerError = error
    self.action = action
    
    self.router.presentFullScreen(.noInternet(self))
  }
  func processAction() {
    action?()
    router.dismiss()
    
    resetParams()
  }
}

//MARK: - Helpers
private extension ErrorProcessorProvider {
  func resetParams() {
    outerError = nil
    action = nil
  }
}
