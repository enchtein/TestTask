//
//  NoInternetView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

struct NoInternetView: View {
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  let action: () -> Void
  
  var body: some View {
    VStack(spacing: constants.spacing) {
      icon
      
      msg
      
      CommonButton(title: "Try again", isActive: .constant(true)) {
        action()
      }
    }
  }
}

//MARK: - UI elements creating
private extension NoInternetView {
  var icon: some View {
    AppImage.NoInternet.logo
      .resizable()
      .frame(size: constants.iconSize)
  }
  
  var msg: some View {
    Text("There is no internet connection")
      .foregroundStyle(constants.textColor)
      .font(constants.font)
  }
}

//MARK: - Preview
#Preview {
  NoInternetView(action: {})
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
}


