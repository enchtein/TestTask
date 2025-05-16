//
//  CodableJson.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 16.05.2025.
//

import Foundation

protocol DecodableJson {
  init?(data: Data)
  init?(_ json: String, using encoding: String.Encoding)
  init?(fromURL url: String)
}

extension DecodableJson where Self: Decodable{
  init?(data: Data) {
    guard let me = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
    self = me
  }
}

extension DecodableJson {
  init?(_ json: String, using encoding: String.Encoding = .utf8) {
    guard let data = json.data(using: encoding) else { return nil }
    self.init(data: data)
  }
  
  init?(fromURL url: String) {
    guard let url = URL(string: url), let data = try? Data(contentsOf: url) else { return nil }
    self.init(data: data)
  }
}

protocol EncodableJson {
  var jsonData: Data? { get }
  var json: String? { get }
}

extension EncodableJson where Self: Encodable {
  var jsonData: Data? {
    return try? JSONEncoder().encode(self)
  }
  
  var json: String? {
    guard let data = self.jsonData else { return nil }
    return String(data: data, encoding: .utf8)
  }
}

typealias CodableJson = DecodableJson & EncodableJson

struct JSON {
  static let encoder = JSONEncoder()
}

extension Encodable {
  subscript(key: String) -> Any? {
    return dictionary[key]
  }
  var dictionary: [String: Any] {
    return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
  }
}

extension Array: CodableJson where Element: Codable {}

extension Array where Element: Any {
  func convertIntoJSONString() -> String? {
    do {
      let jsonData: Data = try JSONSerialization.data(withJSONObject: self, options: [])
      if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
        return jsonString as String
      }
    } catch let error as NSError {
      print("Error Array convertIntoJSON - \(error.description)")
    }
    return nil
  }
}

public extension Dictionary where Key == String, Value == Any {
  func decode<T: Codable>(to type: T.Type) -> T? {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
      let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
      return decodedObject
    } catch {
      print("Error decoding: \(error)")
      return nil
    }
  }
  
  func encode<T: Codable>(from object: T) -> [String: Any]? {
    do {
      let jsonData = try JSONEncoder().encode(object)
      let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
      return jsonObject as? [String: Any]
    } catch {
      print("Error encoding: \(error)")
      return nil
    }
  }
}
