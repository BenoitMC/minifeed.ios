import Foundation
import UIKit

extension UIView {
  var isVisible : Bool {
    get { return !isHidden }
    set { isHidden = !newValue }
  }
}
