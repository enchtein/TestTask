//
//  MainView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

struct MainView: View {
  private var constants: Constants { Constants(orientationInfo) }
  private let dataSource = TabType.allCases
  
  @State private var selectedTab: TabType = TabType.users
  @StateObject private var router: MainRouter
  @StateObject private var sharedData: SharedData
  
  @EnvironmentObject private var orientationInfo: OrientationInfo
  @EnvironmentObject private var networkMonitor: NetworkMonitor
  
  init(router: MainRouter) {
    _router = StateObject(wrappedValue: router)
    _sharedData = StateObject(wrappedValue: SharedData())
  }
  
  var body: some View {
    ZStack {
      AppColor.background.ignoresSafeArea()
      
      VStack(spacing: .zero) {
        headerView
          
        tabView
          .layoutPriority(1)
        
        tabBarView
      }
    }
    .ignoresSafeArea(.keyboard)
  }
  
  private var tabView: some View {
    TabView(selection: $selectedTab) {
      ForEach(dataSource) { type in
        tabItemView(for: type)
          .tag(type)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .animation(.easeInOut, value: selectedTab)
    .transition(.slide)
    .onChange(of: selectedTab) { newValue in
      UIApplication.shared.hideKeyboard()
    }
  }
  private var tabBarView: some View {
    HStack(spacing: .zero) {
      ForEach(dataSource) { type in
        tabItemButton(for: type)
          .frame(maxWidth: .infinity)
          .background(constants.colorTheme.tabViewBg)
      }
    }
  }
}

//MARK: - UI elements creating
private extension MainView {
  var headerViewText: Text {
    switch selectedTab {
    case .users:
      Text("Working with GET request")
    case .singUp:
      Text("Working with POST request")
    }
  }
  var headerView: some View {
    ZStack {
      constants.colorTheme.headerBg
      
      headerViewText
        .font(constants.headerFont)
        .foregroundStyle(constants.colorTheme.headerText)
        .padding(constants.tabItemVIndent)
        .animation(.easeInOut, value: selectedTab)
    }
  }
  
  @ViewBuilder
  func tabItemView(for type: TabType) -> some View {
    switch type {
    case .users:
      UsersView(router: router, sharedData: sharedData)
    case .singUp:
      CreateUserView(router: router, sharedData: sharedData)
    }
  }
  func tabItemButton(for type: TabType) -> some View {
    Button {
      selectedTab = type
    } label: {
      HStack(spacing: constants.tabItemHStackSpacing) {
        type.image
        type.title
      }
      .padding(.vertical, constants.tabItemVIndent)
      .tint(tabItemTint(for: type))
    }
  }
}

//MARK: - Helpers
private extension MainView {
  func tabItemTint(for type: TabType) -> Color {
    selectedTab == type ? constants.colorTheme.selectedTabTint : constants.colorTheme.unSelectedTabTint
  }
}

//MARK: - Preview
#Preview {
  MainView(router: .default)
    .environmentObject(OrientationInfo.phone)
    .environmentObject(NetworkMonitor.shared)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  let colorTheme = AppColor.MainView.self
  
  let tabItemHStackSpacing: CGFloat = 8.0
  let tabItemVIndent: CGFloat = 16.0
  
  var headerFont: Font {
    let phoneFont = 20.0
    return AppFont.font(.regular, size: phoneFont + additionalValue)
  }
}
