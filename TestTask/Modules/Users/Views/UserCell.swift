//
//  UserCell.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI
import Kingfisher

struct UserCell: View {
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  let user: User
  let isLastCell: Bool
  
  var body: some View {
    HStack(alignment: .top, spacing: constants.hStackSpacing) {
      userAvatar
      
      ZStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: constants.vStackSpacing) {
          createSubVStack(firstText: name, secondText: position)
          
          createSubVStack(firstText: email, secondText: phone)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.bottom, constants.vPadding)
        
        if !isLastCell {
          Divider()
            .frame(height: 1)
            .background(constants.dividerColor)
            .opacity(0.25)
        }
      }
    }
    .padding(.top, constants.vPadding)
  }
  
  @ViewBuilder
  var userAvatar: some View {
    if let url = URL(string: user.photo) {
      KFImage(url)
        .placeholder {
          ProgressView()
        }
        .onFailureImage(
          avatarPlaceholder
            .renderer()
            .uiImage
        )
        .resizable()
        .scaledToFill()
        .clipShape(Circle())
        .frame(size: constants.iconSize)
    } else {
      avatarPlaceholder
        .resizable()
        .scaledToFill()
        .clipShape(Circle())
        .frame(size: constants.iconSize)
    }
  }
}

//MARK: - UI elements creating
private extension UserCell {
  private var avatarPlaceholder: Image {
    Image(systemName: "person.circle")
  }
  
  var name: some View {
    Text(user.name)
      .font(constants.nameFont)
      .foregroundStyle(constants.baseText)
  }
  var position: some View {
    Text(user.position)
      .font(constants.additionalFont)
      .foregroundStyle(constants.secondaryText)
  }
  var email: some View {
    Text(user.email)
      .lineLimit(1)
      .font(constants.additionalFont)
      .foregroundStyle(constants.baseText)
  }
  var phone: some View {
    Text(user.phone)
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
  UserCell(user: .mock, isLastCell: false)
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
