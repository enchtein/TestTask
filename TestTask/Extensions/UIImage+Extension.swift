//
//  UIImage+Extension.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import UIKit

public extension UIImage {
  /// Extension to fix orientation of an UIImage without EXIF
  func fixOrientation() -> UIImage {
    
    guard let cgImage = cgImage else { return self }
    
    if imageOrientation == .up { return self }
    
    var transform = CGAffineTransform.identity
    
    switch imageOrientation {
      
    case .down, .downMirrored:
      transform = transform.translatedBy(x: size.width, y: size.height)
      transform = transform.rotated(by: CGFloat(Double.pi))
      
    case .left, .leftMirrored:
      transform = transform.translatedBy(x: size.width, y: 0)
      transform = transform.rotated(by: CGFloat(Double.pi/2))
      
    case .right, .rightMirrored:
      transform = transform.translatedBy(x: 0, y: size.height)
      transform = transform.rotated(by: CGFloat(-Double.pi/2))
      
    case .up, .upMirrored:
      break
    @unknown default:
      break
    }
    
    switch imageOrientation {
      /// If would problem with orientation add "transform =" instead "_ ="
    case .upMirrored, .downMirrored:
      _ = transform.translatedBy(x: size.width, y: 0)
      _ = transform.scaledBy(x: -1, y: 1)
      
    case .leftMirrored, .rightMirrored:
      _ = transform.translatedBy(x: size.height, y: 0)
      _ = transform.scaledBy(x: -1, y: 1)
      
    case .up, .down, .left, .right:
      break
    @unknown default:
      break
    }
    
    if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
      
      ctx.concatenate(transform)
      
      switch imageOrientation {
        
      case .left, .leftMirrored, .right, .rightMirrored:
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        
      default:
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      }
      
      if let finalImage = ctx.makeImage() {
        return (UIImage(cgImage: finalImage))
      }
    }
    
    // something failed -- return original
    return self
  }
}
