//
//  View+Extension.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

//MARK: - Logic for getting view content size
extension View {
  func sizeReader(_ size: @escaping (CGSize) -> Void) -> some View {
    return self
      .background {
        GeometryReader { geometry in
          Color.clear
            .preference(key: ContentSizeReaderPreferenceKey.self, value: geometry.size)
            .onPreferenceChange(ContentSizeReaderPreferenceKey.self) { newValue in size(newValue) }
        }
        .hidden()
      }
  }
}
fileprivate struct ContentSizeReaderPreferenceKey: PreferenceKey {
  static var defaultValue: CGSize { get { return CGSize() } }
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}

extension View {
  func frame(size: CGSize) -> some View {
    self
      .frame(width: size.width, height: size.height)
  }
}

extension View {
  @MainActor func renderer() -> ImageRenderer<some View> {
    ImageRenderer(content: self)
  }
}

extension View {
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
      
      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
}
