//
//  CreationUserResult.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 18.05.2025.
//

import SwiftUI

struct CreationUserResult: View {
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  let responce: NewUserResponse
  let action: () -> Void
  
  var body: some View {
    ZStack {
      VStack(spacing: constants.spacing) {
        icon
        
        msg
        
        CommonButton(title: buttonTitle, isActive: .constant(true)) {
          action()
        }
      }
      
      closeButtonView
    }
  }
}

//MARK: - UI elements creating
private extension CreationUserResult {
  var image: Image {
    let imageTheme = AppImage.CreationUserResult.self
    return responce.success ? imageTheme.userSuccessCreation : imageTheme.userFailreCreation
  }
  var icon: some View {
    image
      .resizable()
      .frame(size: constants.iconSize)
  }
  
  var msg: some View {
    Text(responce.message)
      .foregroundStyle(constants.textColor)
      .font(constants.font)
  }
  
  var buttonTitle: String {
    responce.success ? "Got it" : "Try again"
  }
  
  var closeButton: some View {
    Button {
      action()
    } label: {
      AppImage.CreationUserResult.close
        .resizable()
        .frame(size: constants.closeButtonSize)
    }
  }
  
  var closeButtonView: some View {
    VStack(spacing: .zero) {
      HStack(spacing: .zero) {
        Spacer()
        closeButton
        Spacer().frame(width: constants.closeButtonSize.width)
      }
      
      Spacer()
    }
  }
}

#Preview {
  CreationUserResult(responce: .mockSuccess, action: {})
    .environmentObject(OrientationInfo.phone)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  private let colorTheme = AppColor.NoInternetView.self
  
  let tabItemHStackSpacing: CGFloat = 8.0
  let tabItemVInden: CGFloat = 16.0
  
  var spacing: CGFloat {
    24.0 + additionalValue
  }
  
  var iconSize: CGSize {
    let sideSize: CGFloat = orientationInfo.isPhone ? 200.0 : 250.0
    return .init(width: sideSize, height: sideSize)
  }
  
  var font: Font {
    let phoneFontSize: CGFloat = 20.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
  var textColor: Color { colorTheme.text }
  
  var closeButtonSize: CGSize {
    let sideSize: CGFloat = orientationInfo.isPhone ? 24.0 : 30.0
    return .init(width: sideSize, height: sideSize)
  }
}
