import Foundation
import UIKit

extension UIAlertController {
  func addTextField(text: String? = nil, placeholder: String? = nil, editingChangedTarget: Any?, editingChangedSelector: Selector?) {
    addTextField { textField in
      textField.text = text
      textField.placeholder = placeholder
      if let target = editingChangedTarget, let selector = editingChangedSelector {
        textField.addTarget(target, action: selector, for: .editingChanged)
      }
    }
  }
}

