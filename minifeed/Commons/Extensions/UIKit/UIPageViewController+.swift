import Foundation
import UIKit

extension UIPageViewController {
  func goToPreviousPage(_ animated: Bool = true, completion: (()->Void)? = nil) {
    guard let currentController = viewControllers?[0] else { return }
    guard let newController = dataSource?.pageViewController(self, viewControllerBefore: currentController) else { return }

    setViewControllers([newController], direction: .reverse, animated: animated) { finished in
      if finished { completion?() }
    }
  }

  func goToNextPage(_ animated: Bool = true, completion: (()->Void)? = nil) {
    guard let currentController = viewControllers?[0] else { return }
    guard let newController = dataSource?.pageViewController(self, viewControllerAfter: currentController) else { return }

    setViewControllers([newController], direction: .forward, animated: animated) { finished in
      if finished { completion?() }
    }
  }
}