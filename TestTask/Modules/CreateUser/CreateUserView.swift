//
//  CreateUserView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI

struct CreateUserView: View {
  @ObservedObject private var router: MainRouter
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  @StateObject private var viewModel: CreateUserViewModel
  @Environment(\.keyboardHeight) var keyboardHeight
  
  @State private var isOnScreen: Bool = false
  
  init(router: MainRouter, sharedData: SharedData) {
    self.router = router
    _viewModel = StateObject(wrappedValue: CreateUserViewModel(sharedData))
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
    .onChange(of: viewModel.loadingState) { newValue in
      guard isOnScreen else { return }
      switch newValue {
      case .error(let error):
        let action = { [weak viewModel, weak router] in
          viewModel?.fetchPositions()
          router?.dismiss()
        }
        router.presentFullScreen(.noInternet(error: error, action))
        
      default: break
      }
    }
    .onAppear {
      isOnScreen = true
      
      viewModel.resetErroredStateIfNeeded()
    }
    .onDisappear {
      isOnScreen = false
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
      
      postionItem
      
      avatarItem
    }
  }
  
  var postionItem: some View {
    VStack(spacing: constants.ftVStackSpacing) {
      Text("Select your position")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      postionList
    }
  }
  var postionList: some View {
    VStack(spacing: .zero) {
      ForEach(viewModel.positions, id: \.self) { position in
        PositionSelectionCell(type: position, selectedType: $viewModel.selectedPostion)
      }
    }
  }
  
  var avatarItem: some View {
    CreateUserFieldContainer(itemObj: viewModel.avatarObj, hIndent: constants.hPadding) {
      CreateUserAvatarField(itemObj: viewModel.avatarObj, hIndent: constants.hPadding)
    }
  }
}

//MARK: - Preview
#Preview {
  CreateUserView(router: .default, sharedData: .init())
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
