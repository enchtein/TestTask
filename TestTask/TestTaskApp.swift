//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 14.05.2025.
//

import SwiftUI

@main
struct TestTaskApp: App {
  @StateObject private var networkMonitor = NetworkMonitor.shared
  @StateObject private var router: MainRouter = .default// = MainRouter(isPresented: .constant(.main))
  
    var body: some Scene {
        WindowGroup {
          ContentView(router: router)
            .environmentObject(networkMonitor)
        }
    }
}
