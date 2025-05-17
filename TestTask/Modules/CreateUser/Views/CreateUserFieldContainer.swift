//
//  CreateUserFieldContainer.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI

struct CreateUserFieldContainer<Content: View>: View {
  @ObservedObject var itemObj: CreateUserFieldObj
  private let hIndent: CGFloat
  let innerView: Content
  
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  init(itemObj: CreateUserFieldObj, hIndent: CGFloat, @ViewBuilder content: () -> Content) {
    self.itemObj = itemObj
    self.hIndent = hIndent
    self.innerView = content()
  }
  
  var body: some View {
    VStack {
      innerView
        .frame(height: constants.height)
        .overlay(
          RoundedRectangle(cornerRadius: constants.radius)
            .stroke(borderColor, lineWidth: 1)
            .animation(.easeInOut, value: itemObj.isErrored)
        )
      
      hintHStack
    }
  }
}
//MARK: - UI elements creating
private extension CreateUserFieldContainer {
  var hPaddingSpacer: some View {
    Spacer()
      .frame(width: hIndent)
  }
  
  var helperMsg: String {
    let prepairText: String
    if itemObj.isErrored {
      if itemObj.isEmptyValue {
        prepairText = itemObj.type.emptyValueErrorMsg
      } else {
        prepairText = itemObj.type.errorMsg
      }
    } else {
      prepairText = itemObj.type.maskText
    }
    
    return prepairText.isEmpty ? " " : prepairText
  }
  var helperColor: Color {
    itemObj.isErrored ? constants.invalidColor : constants.additionalTextColor
  }
  var borderColor: Color {
    itemObj.isErrored ? constants.invalidColor : constants.placeholderOrBorderColor
  }
  
  var hintText: some View {
    Text(helperMsg)
      .font(constants.helperTextFont)
      .foregroundColor(helperColor)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  var hintHStack: some View {
    HStack(spacing: .zero) {
      hPaddingSpacer
      
      hintText
      
      hPaddingSpacer
    }
    .animation(.easeInOut, value: itemObj.isErrored)
  }
}

//MARK: - Preview
#Preview {
  CreateUserFieldContainer(itemObj: .baseMock, hIndent: 16.0) {
    Rectangle()
      .fill(.red)
  }
  .environmentObject(OrientationInfo.phone)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  private let colorTheme = AppColor.CreateUserView.self
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  var height: CGFloat {
    orientationInfo.isPhone ? 56 : 76
  }
  var radius: CGFloat {
    let phoneRadius: CGFloat = 4.0
    return phoneRadius + (additionalValue / 2)
  }
  
  
  var helperTextFont: Font {
    let phoneFontSize: CGFloat = 14.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
  
  var additionalTextColor: Color {
    colorTheme.secondaryText
  }
  var placeholderOrBorderColor: Color {
    colorTheme.placeholderOrBorder
  }
  var invalidColor: Color {
    colorTheme.error
  }
}
