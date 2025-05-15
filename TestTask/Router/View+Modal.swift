//
//  View+Modal.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

extension View {
  func modal<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, content: @escaping (Item) -> Content) -> some View where Item: Identifiable, Content: View {
    ZStack(alignment: .center) {
      self
      if let wrappedItem = item.wrappedValue {
        Color.black.opacity(0.5)
          .ignoresSafeArea()
          .onTapGesture {
            item.wrappedValue = nil
          }
        content(wrappedItem)
      }
    }
  }
}
