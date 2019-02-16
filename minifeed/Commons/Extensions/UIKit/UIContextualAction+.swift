import Foundation
import UIKit

extension UIContextualAction {
  convenience init(title: String, _ callback: @escaping ()->Void) {
    self.init(style: .normal, title: title) { _, _, completionHandler in
      completionHandler(true)
      callback()
    }

    backgroundColor = .iosBlue
  }
}