//
//  PositionSelectionCell.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI

struct PositionSelectionCell: View {
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  private let type: Position
  @Binding var selectedType: Position?
  
  init(type: Position, selectedType: Binding<Position?>) {
    self.type = type
    _selectedType = selectedType
  }
  
  var body: some View {
    Button {
      selectedType = type
    } label: {
      HStack(spacing: constants.hStackSpacing) {
        selectionIcon
        
        Text(type.name)
          .font(constants.font)
          .foregroundStyle(constants.textColor)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .frame(height: constants.contentHeight)
    .animation(.easeInOut, value: selectedType)
    
  }
  
  var selectionIcon: some View {
    ZStack {
      Rectangle()
        .fill(.clear)
        .aspectRatio(contentMode: .fit)
      circleIcon
        .frame(size: constants.iconSize)
      
    }
  }
  
  @ViewBuilder
  var circleIcon: some View {
    if let selectedType, type == selectedType {
      selectedIcon
    } else {
      unSelectedIcon
    }
    
  }
  var selectedIcon: some View {
    ZStack {
      Circle()
        .fill(constants.selectedOuterColor)
      
      Circle()
        .fill(constants.selectedInnerColor)
        .frame(size: constants.dotIconSize)
    }
  }
  var unSelectedIcon: some View {
    ZStack {
      Circle()
        .stroke(constants.unSelectedBorderColor, lineWidth: 1)
    }
  }
}

//MARK: - Preview
#Preview {
  PositionSelectionCell(type: .mock, selectedType: .constant(.mock))
    .environmentObject(OrientationInfo.phone)
}
//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  private let colorTheme = AppColor.CreateUserView.self
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  var hStackSpacing: CGFloat {
    let phoneSpacing: CGFloat = 8.0
    return phoneSpacing + additionalValue
  }
  
  var iconSize: CGSize {
    .init(width: 14.0, height: 14.0)
  }
  var dotIconSize: CGSize {
    .init(width: 6.0, height: 6.0)
  }
  
  var contentHeight: CGFloat {
    let phoneHeight: CGFloat = 48.0
    return phoneHeight + additionalValue
  }
  
  //Colors
  var selectedInnerColor: Color {
    colorTheme.selectedInner
  }
  var selectedOuterColor: Color {
    colorTheme.selectedOuter
  }
  
  var unSelectedBorderColor: Color {
    colorTheme.unSelectedBorder
  }
  
  var textColor: Color {
    colorTheme.baseText
  }
  var font: Font {
    let phoneFontSize = 16.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
}
