import Foundation
import UIKit

extension UITableView {
  func deselect(_ indexPath: IndexPath, _ animated: Bool = true) {
    deselectRow(at: indexPath, animated: animated)
  }

  convenience init(style: UITableView.Style) {
    self.init(frame: .zero, style: style)
  }
}
