//
//  CommonButton.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

struct CommonButton: View {
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  let title: String
  @Binding var isActive: Bool
  
  let action: () -> Void
  
  @State private var size: CGSize = .zero
  private var cornerRadius: CGFloat {
    size.height / 2
  }
  
  init(title: String, isActive: Binding<Bool>, action: @escaping () -> Void) {
    self.title = title
    _isActive = isActive
    
    self.action = action
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      Text(title)
        .font(constants.font)
        .foregroundStyle(textColor)
        .padding(.vertical, 12.0)
        .padding(.horizontal, 31.5)
    }
    .disabled(!isActive)
    .sizeReader { proxy in
      size = proxy
    }
    .background {
      bgColor
        .cornerRadius(cornerRadius)
    }
    .animation(.linear, value: isActive)
  }
  
  var textColor: Color {
    isActive ? constants.text : constants.inactiveText
  }
  var bgColor: Color {
    isActive ? constants.bg : constants.inactiveBg
  }
}

//MARK: - Preview
#Preview {
  CommonButton(title: "Try again", isActive: .constant(true)) {}
    .environmentObject(OrientationInfo.phone)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  private let colorTheme = AppColor.CommonButton.self
  
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  var bg: Color { colorTheme.bg }
  var inactiveBg: Color { colorTheme.inactiveBg }
  
  var text: Color { colorTheme.text }
  var inactiveText: Color { colorTheme.inactiveText }
  
  var font: Font {
    let phoneFontSize: CGFloat = 18.0
    return AppFont.font(.semibold, size: phoneFontSize + additionalValue)
  }
}
