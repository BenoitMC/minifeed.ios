import Foundation
import UIKit

extension UIColor {
  static let iosBlue = UIView().tintColor!

  convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
    self.init(red: red.cgFloat / 255.0, green: green.cgFloat / 255.0, blue: blue.cgFloat / 255.0, alpha: alpha)
  }

  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let red = (hex >> 16) & 0xFF
    let green = (hex >> 8) & 0xFF
    let blue = hex & 0xFF

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
