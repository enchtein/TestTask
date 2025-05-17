//
//  UIApplication+Extension.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI

extension UIApplication {
  func addHideKeyboardTapGestureRecognizer() {
    guard let window = UIApplication.shared.connectedScenes
      .map({ $0 as? UIWindowScene })
      .compactMap({ $0 })
      .first?
      .windows
      .first else { return }
    let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
    tapGesture.requiresExclusiveTouchType = false
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    window.addGestureRecognizer(tapGesture)
  }
  
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

extension UIApplication: @retroactive UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}
