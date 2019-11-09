import Foundation
import UIKit

extension UINavigationController {
  func setViewControllers(_ controllers: [UIViewController]) {
    setViewControllers(controllers, animated: false)
  }

  func popToRoot(_ animated: Bool = true) {
    popToRootViewController(animated: animated)
  }
}
