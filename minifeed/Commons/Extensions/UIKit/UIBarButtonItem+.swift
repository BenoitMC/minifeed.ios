import Foundation
import UIKit

extension UIBarButtonItem {
  convenience init(image: UIImage) {
    self.init()

    self.image = image
  }

  convenience init(image: String) {
    self.init(image: UIImage.find(image))
  }
}
