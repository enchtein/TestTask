//
//  LoadingState.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

enum LoadingState: Equatable {
  case idle
  case loading
  case success
  case error(Error)
  case userCreationResult(NewUserResponse)
  
  private var descriptionText: String {
    switch self {
    case .idle: "idle"
    case .loading: "loading"
    case .success: "success"
    case .error(let error): error.localizedDescription
    case .userCreationResult(let responce): responce.message
    }
  }
  
  static func ==(lhs: LoadingState, rhs: LoadingState) -> Bool {
    lhs.descriptionText.elementsEqual(rhs.descriptionText)
  }
}
