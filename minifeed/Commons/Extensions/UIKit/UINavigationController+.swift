import Foundation
import UIKit

extension UINavigationController {
  func setViewControllers(_ controllers: [UIViewController]) {
    setViewControllers(controllers, animated: false)
  }
}