import Foundation
import UIKit

extension UIImage {
  static func find(_ name: String) -> UIImage {
    return UIImage(named: name)!
  }

  func filled(withColor color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.setFill()
    guard let context = UIGraphicsGetCurrentContext() else { return self }

    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(CGBlendMode.normal)

    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    guard let mask = cgImage else { return self }
    context.clip(to: rect, mask: mask)
    context.fill(rect)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
}
