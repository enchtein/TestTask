//
//  MainRouter.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

public class MainRouter: Router {
  override func view(view: AppView, route: Route) -> AnyView {
    AnyView(
      buildView(view: view, route: route)
    )
  }
  
  override func presentationDetents(for view: AppView) -> Set<PresentationDetent> {
    let detents: Set<PresentationDetent>
    switch view {
    default:
      detents = [.large]
    }
    if detents.isEmpty {
      fatalError("Detents cannot be empty")
    }
    return detents
  }
  
  static var `default`: MainRouter {
    return MainRouter(isPresented: .constant(.main))
  }
}

extension MainRouter {
  
  @ViewBuilder
  func buildView(view: AppView, route: Route) -> some View {
    switch view {
    case .noInternet(let processor):
      NoInternetView(errorProcessor: processor)
    case .createUserResult(let responce, let action):
      CreationUserResult(responce: responce, action: action)
    default:
      EmptyView()
    }
  }
  
  func router(route: Route) -> MainRouter {
    switch route {
    case .navigation:
      return self
    case .sheet:
      return MainRouter(isPresented: presentingSheet)
    case .fullScreenCover:
      return MainRouter(isPresented: presentingFullScreen)
    case .modal:
      return self
    case .modalOnAllApp:
      return self
    }
  }
}
