import Foundation
import UIKit

extension UIView {
  var isVisible : Bool {
    get { return !isHidden }
    set { isHidden = !newValue }
  }

  var height: CGFloat {
    get {
      return frame.size.height
    }
    set {
      frame.size.height = newValue
    }
  }

  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.masksToBounds = true
      layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
    }
  }
}
