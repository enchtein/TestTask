//
//  UsersViewModel.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
  private let maxCountOfUsersOnPage: Int = 10
  @Published private(set) var loadingState: LoadingState = .idle
  
  private var lastUserListInfo: UserListDTO? { userListInfo.last }
  
  private(set) var userListInfo = [UserListDTO]()
  @Published private(set) var users = [User]()
  
  init() {
    fetchUsersIfNeeded()
    print("UsersViewModel init")
  }
  deinit {
    print("UsersViewModel deinit")
  }
}

//MARK: - API
extension UsersViewModel {
  func fetchUsersIfNeeded() {
    guard let newFilter = createActualFilter() else { return }
    fetchUsers(by: newFilter)
  }
  
  func resetErroredStateIfNeeded() {
    switch loadingState {
    case .error(_):
      let orgState = loadingState
      
      loadingState = .idle
      loadingState = orgState
    default: break
    }
  }
}
//MARK: - Network layer
private extension UsersViewModel {
  func fetchUsers(by filter: UserListFilter) {
    loadingState = .loading
    Task {
      do {
        let res = try await NetworkAdapter.fetchUserList(by: filter)
        
        processingInfo(from: res)
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
//MARK: - Helpers
private extension UsersViewModel {
  func createActualFilter() -> UserListFilter? {
    let newFilter: UserListFilter?
    if let lastUserListInfo {
      if lastUserListInfo.links.nextURL != nil {
        newFilter = UserListFilter(page: lastUserListInfo.page + 1, count: maxCountOfUsersOnPage)
      } else {
        newFilter = nil // all info loaded
      }
    } else {
      newFilter = UserListFilter(page: 1, count: maxCountOfUsersOnPage)
    }
    
    return newFilter
  }
  
  func processingInfo(from list: UserListDTO) {
    let existPages = userListInfo.filter { $0.page != list.page }
    
    var newUserListInfo = existPages
    newUserListInfo.append(list)
    
    userListInfo = newUserListInfo
    
    let allUsers = newUserListInfo.map { $0.users }.reduce([], +)
    users = allUsers
  }
}
