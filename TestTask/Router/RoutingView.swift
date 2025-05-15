//
//  RoutingView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

struct RoutingView<Content: View>: View {
  @StateObject var router: Router
  private let content: Content
  
  init(router: Router, @ViewBuilder content: @escaping () -> Content) {
    _router = StateObject(wrappedValue: router)
    self.content = content()
    _alertIsPresented = State(initialValue: false)
  }
  
  @State private var alertIsPresented: Bool
  
  var body: some View {
    NavigationStack(path: router.navigationPath) {
      content
        .navigationDestination(for: AppView.self) { view in
          router.view(view: view, route: .navigation)
        }
    }.sheet(item: router.presentingSheet) { view in
      router.view(view: view, route: .sheet)
    }.fullScreenCover(item: router.presentingFullScreen) { view in
      router.view(view: view, route: .fullScreenCover)
    }.modal(item: router.presentingModal) { view in
      router.view(view: view, route: .modal)
    }
  }
}
