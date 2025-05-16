//
//  NetworkTarget.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

import Foundation
import Moya

enum NetworkTarget {
  case getUsersList(_ filter: UserListFilter)
}

extension NetworkTarget: TargetType {
  var actionName: String {
    switch self {
    case .getUsersList: "users"
    }
  }
  var baseURL: URL {
    URL(string: "https://frontend-test-assignment-api.abz.agency")!
  }
  
  var path: String {
    switch self {
    case .getUsersList: "api/v1/" + actionName
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getUsersList: .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getUsersList(let filter):
        .requestParameters(parameters: filter.dictionary, encoding: URLEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    var dictionary = [String: String]()
    dictionary["Content-Type"] = "application/json"
    
    return dictionary
  }
}
