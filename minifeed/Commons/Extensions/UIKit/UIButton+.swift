import Foundation
import UIKit
import SwifterSwift

extension UIButton {
  convenience init(title: String? = nil) {
    self.init()

    if let title = title {
      setTitleForAllStates(title)
    }
  }
}