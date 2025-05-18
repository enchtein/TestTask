//
//  UsersView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

struct UsersView: View {
  @ObservedObject private var router: MainRouter
  @EnvironmentObject private var orientationInfo: OrientationInfo
  @EnvironmentObject private var networkMonitor: NetworkMonitor
  
  private var constants: Constants { Constants(orientationInfo) }
  @StateObject private var viewModel: UsersViewModel
  
  @State private var isOnScreen: Bool = false
  
  init(router: MainRouter, sharedData: SharedData) {
    self.router = router
    _viewModel = StateObject(wrappedValue: UsersViewModel(sharedData))
  }
  
  var body: some View {
    mainContent
      .animation(.easeInOut, value: viewModel.users)
      .onChange(of: viewModel.loadingState) { newValue in
        guard isOnScreen else { return }
        switch newValue {
        case .error(let error):
          let action = { [weak viewModel, weak router] in
            viewModel?.fetchUsersIfNeeded()
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
  private var mainContent: some View {
    if viewModel.users.isEmpty {
      noUsersView
    } else {
      usersListView
    }
  }
}
//MARK: - UI elements creating
private extension UsersView {
  var noUsersView: some View {
    VStack(spacing: constants.spacing) {
      AppImage.Users.noUsers
        .resizable()
        .frame(size: constants.iconSize)
      
      Text("There are no users yet")
        .foregroundStyle(constants.textColor)
        .font(constants.font)
      
      if viewModel.loadingState == .loading {
        spinner
      }
    }
    .animation(.easeInOut, value: viewModel.loadingState)
  }
  
  var usersListView: some View {
    VStack(spacing: .zero) {
      ScrollView {
        LazyVStack(spacing: .zero) {
          ForEach(viewModel.users, id: \.self) { user in
            let isLast = viewModel.users.last?.id == user.id
            UserCell(user: user, isLastCell: isLast)
              .onAppear {
                if isLast {
                  viewModel.fetchUsersIfNeeded()
                }
              }
          }
        }
      }
      
      if viewModel.loadingState == .loading {
        spinner
      }
    }
    .padding(.horizontal, constants.hPadding)
    .animation(.easeInOut, value: viewModel.loadingState)
  }
  
  var spinner: some View {
    ProgressView()
      .controlSize(constants.spinnerSize)
      .padding(.bottom, constants.spacing)
  }
}

//MARK: - Preview
#Preview {
  UsersView(router: .default, sharedData: .init())
    .environmentObject(OrientationInfo.phone)
    .environmentObject(NetworkMonitor.shared)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  private let colorTheme = AppColor.UsersView.self
  
  var iconSize: CGSize {
    let sideSize: CGFloat = orientationInfo.isPhone ? 200.0 : 250.0
    return .init(width: sideSize, height: sideSize)
  }
  
  var font: Font {
    let phoneFontSize: CGFloat = 20.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
  var textColor: Color { AppColor.mainText }
  
  var spinnerSize: ControlSize {
    orientationInfo.isPhone ? .regular : .large
  }
  
  var spacing: CGFloat {
    24.0 + additionalValue
  }
  
  var hPadding: CGFloat {
    16.0 + additionalValue
  }
}
