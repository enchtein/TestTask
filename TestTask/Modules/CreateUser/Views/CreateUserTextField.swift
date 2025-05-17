//
//  CreateUserTextField.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI

struct CreateUserTextField: View {
  @ObservedObject var itemObj: CreateUserTextFieldObj
  private let hIndent: CGFloat
  
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  @FocusState private var isFocused: Bool
  
  //---> internal properties
  @State private var tfText: String = ""
  private var currentHelpersColor: Color {
    itemObj.isErrored ? constants.invalidColor : constants.placeholderOrBorderColor
  }
  //<--- internal properties
  
  init(itemObj: CreateUserTextFieldObj, hIndent: CGFloat) {
    self.itemObj = itemObj
    self.hIndent = hIndent
    
    isFocused = .init(itemObj.isFocused)
    _tfText = .init(initialValue: itemObj.text)
  }
  
  var body: some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          itemObj.isFocused = true
        }
      
      VStack(alignment: .leading, spacing: .zero) {
        if itemObj.isErrored {
          hintText
        }
        
        textField
          .focused($isFocused)
      }
      .padding(.horizontal, hIndent)
      .animation(.easeInOut, value: itemObj.isErrored)
    }
    .onChange(of: itemObj.isFocused) { newValue in
      if isFocused != newValue {
        isFocused = newValue
      }
    }
    .onChange(of: isFocused) { newValue in
      if itemObj.isFocused != newValue {
        itemObj.isFocused = newValue
      }
    }
  }
}

//MARK: - UI elements creating
private extension CreateUserTextField {
  @ViewBuilder
  var hintText: some View {
    if let hintText = itemObj.type.hintText {
      Text(hintText)
        .font(constants.helperTextFont)
        .foregroundColor(currentHelpersColor)
    }
  }
  
  var textField: some View {
    TextField("", text: $tfText)
      .keyboardType(itemObj.type.kbType)
      .font(constants.font)
      .foregroundStyle(constants.textColor)
      .placeholder(when: itemObj.text.isEmpty) {
        Text(itemObj.type.placeholderText)
          .font(constants.helperTextFont)
          .foregroundColor(currentHelpersColor)
      }
      .onChange(of: tfText) { newValue in
        if itemObj.text != newValue {
          itemObj.text = newValue
        }
      }
      .onChange(of: itemObj.text) { newValue in
        if tfText != newValue {
          tfText = newValue
        }
      }
  }
}

//MARK: - Preview
#Preview {
  CreateUserTextField(itemObj: .mock, hIndent: 16.0)
    .environmentObject(OrientationInfo.phone)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  private let colorTheme = AppColor.CreateUserView.self
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  var font: Font {
    let phoneFontSize: CGFloat = 16.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
  var helperTextFont: Font {
    let phoneFontSize: CGFloat = 14.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
  
  var textColor: Color {
    colorTheme.baseText
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
