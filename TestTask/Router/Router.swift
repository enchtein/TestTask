//
//  Router.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

public class Router: ObservableObject {
  enum Route {
    case navigation
    case sheet
    case fullScreenCover
    case modal
    case modalOnAllApp
  }
  
  struct RouterState {
    var navigationPath: [AppView] = []
    var presentingSheet: AppView? = nil
    var presentingFullScreen: AppView? = nil
    var presentingModal: AppView? = nil
    var presentionModalOnAllApp: AppView? = nil
    var isPresented: Binding<AppView?>
    
    var isPresenting: Bool {
      presentingSheet != nil || presentingFullScreen != nil || presentingModal != nil || presentionModalOnAllApp != nil
    }
  }
  
  @Published private(set) var state: RouterState
  init(isPresented: Binding<AppView?>) {
    state = RouterState(isPresented: isPresented)
  }
  
  func view(view: AppView, route: Route) -> AnyView {
    AnyView(EmptyView())
  }
  
  func presentationDetents(for view: AppView) -> Set<PresentationDetent> {
    return Set<PresentationDetent>([.large])
  }
  
  var memoryPointer: String {
    "Router memory pointer = \(Unmanaged.passUnretained(self).toOpaque())"
  }
}

extension Router {
  func navigateTo(_ appView: AppView) {
    state.navigationPath.append(appView)
  }
  
  func navigateBack() {
    state.navigationPath.removeLast()
  }
  
  func navigateToRoot() {
    state.navigationPath.removeAll()
  }
  
  func replaceNavigationStack(path: [AppView]) {
    state.navigationPath = path
  }
  
  func presentSheet(_ appView: AppView) {
    state.presentingSheet = appView
  }
  
  func presentFullScreen(_ appView: AppView) {
    state.presentingFullScreen = appView
  }
  
  func presentModal(_ appView: AppView) {
    state.presentingModal = appView
  }
  
  func presentModalOnAllApp(_ appView: AppView) {
    state.presentionModalOnAllApp = appView
  }
  
  func dismiss() {
    DispatchQueue.main.async {
      self.handleStateOnDismiss()
    }
  }
  
  private func handleStateOnDismiss() {
    if state.presentingSheet != nil {
      state.presentingSheet = nil
    } else if state.presentingFullScreen != nil {
      state.presentingFullScreen = nil
    } else if state.presentingModal != nil {
      state.presentingModal = nil
    } else if state.presentionModalOnAllApp != nil {
      state.presentionModalOnAllApp = nil
    } else if navigationPath.count >= 1 {
      state.navigationPath.removeLast()
    } else {
      state.isPresented.wrappedValue = nil
    }
  }
}

extension Router {
  var navigationPath: Binding<[AppView]> {
    binding(keyPath: \.navigationPath)
  }
  
  var presentingSheet: Binding<AppView?> {
    binding(keyPath: \.presentingSheet)
  }
  
  var presentingFullScreen: Binding<AppView?> {
    binding(keyPath: \.presentingFullScreen)
  }
  
  var presentingModal: Binding<AppView?> {
    binding(keyPath: \.presentingModal)
  }
  
  var presentionModalOnAllApp: Binding<AppView?> {
    binding(keyPath: \.presentionModalOnAllApp)
  }
  
  var isPresented: Binding<AppView?> {
    state.isPresented
  }
}

private extension Router {
  func binding<T>(keyPath: WritableKeyPath<RouterState, T>) -> Binding<T> {
    Binding(
      get: { self.state[keyPath: keyPath] },
      set: { self.state[keyPath: keyPath] = $0 }
    )
  }
}
