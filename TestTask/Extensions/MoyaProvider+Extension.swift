//
//  MoyaProvider+Extension.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

import Foundation
import Moya
import Alamofire

extension MoyaProvider {
  func request<Object: Codable>(_ target: Target,
                                file: String = #file,
                                line: Int = #line,
                                function: String = #function) async throws -> Object {
    do {
      let result = try await withCheckedThrowingContinuation { continuation in
        self.request(target) { result in
          switch result {
          case .success(let response):
            do {
              let response = try JSONDecoder().decode(Object.self, from: response.data)
              continuation.resume(returning: response)
            } catch let error {
              continuation.resume(throwing: error)
            }
          case .failure(let error):
            continuation.resume(throwing: error)
          }
        }
      }
      
      return result
    } catch {
      throw error
    }
  }
  func request(_ target: Target,
               file: String = #file,
               line: Int = #line,
               function: String = #function) async throws -> Data {
    do {
      let result = try await withCheckedThrowingContinuation { continuation in
        self.request(target) { result in
          switch result {
          case .success(let response):
            continuation.resume(returning: response.data)
          case .failure(let error):
            continuation.resume(throwing: error)
          }
        }
      }
      
      return result
    } catch {
      throw error
    }
  }
  
  func requestWithEmptyResponse(_ target: Target,
                                file: String = #file,
                                line: Int = #line,
                                function: String = #function) async throws {
    do {
      let result: () = try await withCheckedThrowingContinuation { continuation in
        self.request(target) { result in
          switch result {
          case .success(_):
            continuation.resume()
          case .failure(let error):
            continuation.resume(throwing: error)
          }
        }
      }
      
      return result
    } catch {
      throw error
    }
  }
}


extension Data {
  func printJSON() {
    if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
      debugPrint(JSONString)
    }
  }
}
