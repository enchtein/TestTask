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
  
  static func fetchPositions() async throws -> PositionsList {
    try await provider.request(.getPositionsList)
  }
  
  static func fetchToken() async throws -> TokenDTO {
    try await provider.request(.getToken)
  }
  static func create(_ newUser: NewUserDTO, with token: String) async throws -> NewUserResponse {
    try await provider.request(.create(newUser, token: token))
  }
}
