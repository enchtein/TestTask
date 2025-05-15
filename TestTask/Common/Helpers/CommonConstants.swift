//
//  CommonConstants.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import Foundation

protocol CommonConstants {
  var orientationInfo: OrientationInfo { get set }
  
  var additionalValue: CGFloat { get }
}
extension CommonConstants {
  var additionalValue: CGFloat {
    orientationInfo.isPhone ? .zero : 4.0
  }
}
