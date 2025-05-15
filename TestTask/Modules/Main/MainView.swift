//
//  MainView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

struct MainView: View {
  private let constants = Constants()
  private let dataSource = TabType.allCases
  
  @State private var selectedTab: TabType = TabType.users
  @StateObject private var router: MainRouter
  init(router: MainRouter) {
    _router = StateObject(wrappedValue: router)
  }
  
  var body: some View {
    ZStack {
      AppColor.background.ignoresSafeArea()
      
      VStack(spacing: .zero) {
        tabView
        tabBarView
      }
    }
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
  @ViewBuilder
  func tabItemView(for type: TabType) -> some View {
    switch type {
    case .users:
      Rectangle().fill(.orange)
        .overlay {
          Button {
                        router.presentFullScreen(.test)
            
            
            
            
//            router.navigateTo(.test)
//            router.presentSheet(.test)
//            router.presentFullScreen(.test)
//            withAnimation {
//              router.presentModal(.test)
//            }
//            withAnimation {
//              router.presentModalOnAllApp(.test)
//            }
            
          } label: {
            Text("presentFullScreen")
          }

        }
    case .singUp:
      Rectangle().fill(.red)
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
      .padding(.vertical, constants.tabItemVInden)
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
}

//MARK: - Constants
fileprivate struct Constants {
  let colorTheme = AppColor.MainView.self
  
  let tabItemHStackSpacing: CGFloat = 8.0
  let tabItemVInden: CGFloat = 16.0
}
