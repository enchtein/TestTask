//
//  NetworkAdapter.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

import Moya

struct NetworkAdapter {
  static private let provider: MoyaProvider<NetworkTarget> = {
    MoyaProvider<NetworkTarget>()
  }()
  
  static func fetchUserList(by filter: UserListFilter) async throws -> UserListDTO {
    try await provider.request(.getUsersList(filter))
  }
}
