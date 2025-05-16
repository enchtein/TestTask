//
//  UsersViewModel.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
  @Published private(set) var loadingState: LoadingState = .idle
  
  @Published private(set) var users: [String] = []
  
  init() {
    fetchUsers()
  }
}

//MARK: - API
extension UsersViewModel {
  func repeatLastTask() {
    fetchUsers()
  }
}
//MARK: - Network layer
private extension UsersViewModel {
  func fetchUsers() {
    loadingState = .loading
    Task {
      do {
        try? await Task.sleep(for: .seconds(3.0))
        
        users = [
          "users_1",
          "users_2",
          "users_3",
          "users_4",
          "users_5",
          "users_6",
          "users_7",
          "users_8",
          "users_9"
        ]
        
        loadingState = .success
      } catch {
        if !NetworkMonitor.shared.isConnected {
          loadingState = .error(ErrorProcessing.noInterner)
        } else {
          loadingState = .error(error)
        }
      }
    }
  }
}
