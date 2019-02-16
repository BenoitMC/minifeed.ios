import Foundation
import UIKit

extension UITableViewRowAction {
  convenience init(title: String, background: UIColor? = nil, _ callback: @escaping ()->Void) {
    self.init(style: .normal, title: title) { _, _ in
      callback()
    }

    backgroundColor = background
  }
}