//
//  ErrorProcessing.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

enum ErrorProcessing: Error {
  case noInterner
  case error(Error)
  
  var errorMsg: String {
    switch self {
    case .noInterner:
      "There is no internet connection"
    case .error(let error):
      error.localizedDescription
    }
  }
}
