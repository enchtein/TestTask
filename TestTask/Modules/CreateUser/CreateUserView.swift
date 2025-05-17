//
//  CreateUserView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI

struct CreateUserView: View {
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  @StateObject private var viewModel: CreateUserViewModel
  @Environment(\.keyboardHeight) var keyboardHeight
  
  init() {
    _viewModel = StateObject(wrappedValue: CreateUserViewModel())
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: constants.commonVStackSpacing) {
        contentVStack
        
        CommonButton(title: "Sign up", isActive: $viewModel.signUpAvailability) {
          viewModel.signUpAction()
        }
        
        kbSpacer
      }
      .padding(.horizontal, constants.hPadding)
      .padding(.vertical, constants.vPadding)
    }
  }
  
  @ViewBuilder
  var kbSpacer: some View {
    if keyboardHeight > 0 {
      Spacer()
        .frame(height: keyboardHeight)
    }
  }
}

//MARK: - UI elements creating
private extension CreateUserView {
  var ftVStack: some View {
    VStack(spacing: constants.ftVStackSpacing) {
      CreateUserFieldContainer(itemObj: viewModel.nameObj, hIndent: constants.hPadding) {
        CreateUserTextField(itemObj: viewModel.nameObj, hIndent: constants.hPadding)
      }
      CreateUserFieldContainer(itemObj: viewModel.emailObj, hIndent: constants.hPadding) {
        CreateUserTextField(itemObj: viewModel.emailObj, hIndent: constants.hPadding)
      }
      CreateUserFieldContainer(itemObj: viewModel.phoneObj, hIndent: constants.hPadding) {
        CreateUserTextField(itemObj: viewModel.phoneObj, hIndent: constants.hPadding)
      }
    }
  }
  
  var contentVStack: some View {
    VStack(spacing: constants.contentVStackSpacing) {
      ftVStack
      
      Rectangle()
        .fill(.orange)
        .frame(height: 400.0)
      
      Rectangle()
        .fill(.red)
        .frame(height: 56.0)
    }
  }
}

//MARK: - Preview
#Preview {
  CreateUserView()
    .environmentObject(OrientationInfo.phone)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  private let colorTheme = AppColor.CreateUserView.self
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  var hPadding: CGFloat {
    let phoneIndent: CGFloat = 16.0
    return phoneIndent + additionalValue
  }
  var vPadding: CGFloat {
    let phoneIndent: CGFloat = 32.0
    return phoneIndent + additionalValue
  }
  
  var commonVStackSpacing: CGFloat {
    let phoneIndent: CGFloat = 16.0
    return phoneIndent + additionalValue
  }
  var contentVStackSpacing: CGFloat {
    let phoneIndent: CGFloat = 24.0
    return phoneIndent + additionalValue
  }
  var ftVStackSpacing: CGFloat {
    let phoneIndent: CGFloat = 12.0
    return phoneIndent + additionalValue
  }
}
