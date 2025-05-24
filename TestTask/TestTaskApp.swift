//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

@main
struct TestTaskApp: App {
  @StateObject var orientationInfo = OrientationInfo.shared
  @StateObject private var networkMonitor = NetworkMonitor.shared
  
  @StateObject private var router: MainRouter = .default
  @StateObject private var errorProcessor = ErrorProcessorProvider.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView(router: router)
        .environmentObject(orientationInfo)
        .environmentObject(networkMonitor)
        .environmentObject(errorProcessor)
        .onAppear {
          UIApplication.shared.addHideKeyboardTapGestureRecognizer()
        }
    }
  }
}
