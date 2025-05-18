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
  
  let error: Error
  let action: () -> Void
  
  var body: some View {
    ZStack {
      AppColor.background.ignoresSafeArea()
      
      VStack(spacing: constants.spacing) {
        icon
        
        msg
        
        CommonButton(title: "Try again", isActive: .constant(true)) {
          action()
        }
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
    errorText()
      .foregroundStyle(constants.textColor)
      .font(constants.font)
  }
  
  func errorText() -> Text {
    if let error = error as? ErrorProcessing {
      Text(error.errorMsg)
    } else {
      Text(error.localizedDescription)
    }
  }
}

//MARK: - Preview
#Preview {
  NoInternetView(error: ErrorProcessing.noInterner, action: {})
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
