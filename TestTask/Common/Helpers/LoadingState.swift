//
//  LoadingState.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

enum LoadingState: Equatable {
  case indle
  case loading
  case success
  case error(Error)
  case readyToRepeatTask
  
  private var descriptionText: String {
    switch self {
    case .indle: "indle"
    case .loading: "loading"
    case .success: "success"
    case .error(let error): error.localizedDescription
    case .readyToRepeatTask: "readyToRepeatTask"
    }
  }
  
  static func ==(lhs: LoadingState, rhs: LoadingState) -> Bool {
    lhs.descriptionText.elementsEqual(rhs.descriptionText)
  }
}
