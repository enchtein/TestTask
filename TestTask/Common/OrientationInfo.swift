//
//  OrientationInfo.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import SwiftUI

final class OrientationInfo: ObservableObject {
  enum Orientation: String {
    case portrait
    case landscape
  }
  
  enum UserInterfaceIdiom: String {
    case phone
    case pad
  }
  
  static public let shared = OrientationInfo()
  @Published var orientation: Orientation
  @Published var idiom: UserInterfaceIdiom
  
  private var _observer: NSObjectProtocol?
  
  private init() {
    self.orientation = UIDevice.isLandscape ? .landscape : .portrait
    self.idiom = UIDevice.isIPhone ? .phone : .pad
    
    // unowned self because we unregister before self becomes invalid
    _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [weak self] note in
      guard let self = self,
            let device = note.object as? UIDevice,
            idiom == .pad else { return }
      
      if device.orientation.isPortrait {
        self.orientation = .portrait
      } else if device.orientation.isLandscape {
        self.orientation = .landscape
      }
    }
  }
  
  deinit {
    if let observer = _observer {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
  var iPadLandscape: Bool {
    return idiom == .pad && orientation == .landscape
  }
  
  var iPadPortrait: Bool {
    return idiom == .pad && orientation == .portrait
  }
  
  var isPad: Bool {
    return idiom == .pad
  }
  
  var isPhone: Bool {
    return idiom == .phone
  }
  
  var description: String {
    return ["Orientation: \(orientation.rawValue)", "UserInterfaceIdiom: \(idiom.rawValue)"].joined(separator: ", ")
  }
  
  static var phone: OrientationInfo {
    let info = OrientationInfo()
    info.orientation = .portrait
    info.idiom = .phone
    return info
  }
  
  static var padPortrait: OrientationInfo {
    let info = OrientationInfo()
    info.orientation = .portrait
    info.idiom = .pad
    return info
  }
  
  static var padLandscape: OrientationInfo {
    let info = OrientationInfo()
    info.orientation = .landscape
    info.idiom = .pad
    return info
  }
}

extension OrientationInfo: Equatable {
  static func == (lhs: OrientationInfo, rhs: OrientationInfo) -> Bool {
    lhs.orientation.rawValue == rhs.orientation.rawValue
  }
}
