//
//  ContentView.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var router: MainRouter
  init(router: MainRouter) {
    _router = StateObject(wrappedValue: router)
  }
  
  var body: some View {
    RoutingView(router: router) {
      MainView(router: router)
        .modal(item: router.presentionModalOnAllApp) { view in
          router.view(view: view, route: .modal)
        }
    }

  }
}

#Preview {
  ContentView(router: .default)
}
