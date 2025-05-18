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
  case getPositionsList
  
  case getToken
  case create(_ newUser: NewUserDTO, token: String)
}

extension NetworkTarget: TargetType {
  var actionName: String {
    switch self {
    case .getUsersList: "users"
    case .getPositionsList: "positions"
    case .getToken: "token"
    case .create: "users"
    }
  }
  var baseURL: URL {
    URL(string: "https://frontend-test-assignment-api.abz.agency")!
  }
  
  var path: String {
    switch self {
    case .getUsersList: "api/v1/" + actionName
    case .getPositionsList: "api/v1/" + actionName
    case .getToken: "api/v1/" + actionName
    case .create: "api/v1/" + actionName
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getUsersList: .get
    case .getPositionsList: .get
    case .getToken: .get
    case .create: .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getUsersList(let filter):
      return .requestParameters(parameters: filter.dictionary, encoding: URLEncoding.default)
    case .getPositionsList:
      return .requestPlain
    case .getToken:
      return .requestPlain
    case .create(let newUser, _):
      let name = MultipartFormBodyPart(provider: .data(newUser.name.data(using: .utf8)!), name: "name", mimeType: "application/json")
      let email = MultipartFormBodyPart(provider: .data(newUser.email.data(using: .utf8)!), name: "email", mimeType: "application/json")
      let phone = MultipartFormBodyPart(provider: .data(newUser.phone.data(using: .utf8)!), name: "phone", mimeType: "application/json")
      let positionId = MultipartFormBodyPart(provider: .data(String(newUser.position_id).data(using: .utf8)!), name: "position_id", mimeType: "application/json")
      
      let photo = MultipartFormBodyPart(provider: .data(newUser.photo.fileName.data(using: .utf8)!), name: newUser.photo.name, mimeType: "application/json")
      let photoData = MultipartFormBodyPart(provider: .data(newUser.photo.file), name: newUser.photo.name, fileName: newUser.photo.fileName, mimeType: newUser.photo.mimeType)
      
      return .uploadMultipartFormData(MultipartFormData(parts: [name, email, phone, positionId, photo, photoData]))
    }
  }
  
  var headers: [String : String]? {
    var dictionary = [String: String]()
    dictionary["Content-Type"] = "application/json"
    
    switch self {
    case .create(_, let token):
      dictionary["Token"] = token
    default: break
    }
    
    return dictionary
  }
}
