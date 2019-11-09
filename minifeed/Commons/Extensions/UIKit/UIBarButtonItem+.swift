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

  static func flexibleSpace() -> UIBarButtonItem {
    return self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  }

  static func fixedSpace(_ width: CGFloat = 0) -> UIBarButtonItem {
    return self.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil).do {
      $0.width = width
    }
  }
}
