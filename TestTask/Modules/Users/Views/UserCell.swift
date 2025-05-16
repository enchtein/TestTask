//
//  UserCell.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

struct UserCell: View {
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  var body: some View {
    
    HStack(alignment: .top, spacing: constants.hStackSpacing) {
      Image(systemName: "person.circle")
        .resizable()
        .frame(size: constants.iconSize)
        .cornerRadius(constants.iconCorner)
      
      ZStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: constants.vStackSpacing) {
          createSubVStack(firstText: name, secondText: position)
          
          createSubVStack(firstText: email, secondText: phone)
        }
        .padding(.bottom, constants.vPadding)
        
        Divider()
          .frame(width: .infinity, height: 1)
          .background(constants.dividerColor)
          .opacity(0.25)
      }
    }
    .padding(.top, constants.vPadding)
  }
}

//MARK: - UI elements creating
private extension UserCell {
  var name: some View {
    Text("Malcolm Bailey")
      .font(constants.nameFont)
      .foregroundStyle(constants.baseText)
  }
  var position: some View {
    Text("Frontend developer")
      .font(constants.additionalFont)
      .foregroundStyle(constants.secondaryText)
  }
  var email: some View {
    Text("jany_murazik51@hotmail.comjany_murazik51@hotmail.comjany_murazik51@hotmail.comjany_murazik51@hotmail.com")
      .lineLimit(1)
      .font(constants.additionalFont)
      .foregroundStyle(constants.baseText)
  }
  var phone: some View {
    Text("+38 (098) 278 76 24")
      .font(constants.additionalFont)
      .foregroundStyle(constants.baseText)
  }
}

//MARK: - UI elements creating (Common)
private extension UserCell {
  func createSubVStack(firstText: some View, secondText: some View) -> some View {
    VStack(alignment: .leading, spacing: constants.vSubStackSpacing) {
      firstText
      secondText
    }
  }
}

//MARK: - Preview
#Preview {
  UserCell()
    .environmentObject(OrientationInfo.phone)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  
  
  var iconSize: CGSize {
    let sideSize: CGFloat = orientationInfo.isPhone ? 50.0 : 75.0
    return .init(width: sideSize, height: sideSize)
  }
  var iconCorner: CGFloat {
    iconSize.height / 2
  }
  
  var hStackSpacing: CGFloat {
    let phoneSpacing: CGFloat = 16.0
    return phoneSpacing + additionalValue
  }
  
  var vPadding: CGFloat {
    24.0 + additionalValue
  }
  var vStackSpacing: CGFloat {
    let phoneSpacing: CGFloat = 8.0
    return phoneSpacing + additionalValue
  }
  var vSubStackSpacing: CGFloat {
    let phoneSpacing: CGFloat = 4.0
    return phoneSpacing + additionalValue
  }
  
  //Colors
  private let colorTheme = AppColor.UsersView.self
  var dividerColor: Color { colorTheme.dividerColor }
  var baseText: Color { colorTheme.baseText }
  var secondaryText: Color { colorTheme.secondaryText }
  
  //Fonts
  var nameFont: Font {
    let phoneFontSize = 18.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
  var additionalFont: Font {
    let phoneFontSize = 14.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
}
