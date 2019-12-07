import Foundation
import UIKit

extension UIButton {
  convenience init(title: String? = nil) {
    self.init()

    if let title = title {
      setTitleForAllStates(title)
    }
  }

  private var states: [UIControl.State] {
    return [.normal, .selected, .highlighted, .disabled]
  }

  func setTitleForAllStates(_ title: String) {
    states.forEach { setTitle(title, for: $0) }
  }
}
