import Foundation
import UIKit

extension UIViewController {
  func alert(_ title: String? = nil, _ message: String, _ callback: (()->Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: t("alert.ok"), style: .default) { _ in callback?() }
    alertController.addAction(action)
    present(alertController)
  }

  func alert(_ message: String, _ callback: (()->Void)? = nil) {
    alert(nil, message, callback)
  }

  func alertError(_ message: String, _ callback: (()->Void)? = nil) {
    alert(t("alert.error"), message, callback)
  }

  func confirm(_ title: String? = nil, _ message: String, _ callback: @escaping ()->Void) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: t("alert.confirm"), style: .default){ _ in callback() })
    alertController.addAction(UIAlertAction(title: t("alert.cancel"), style: .cancel, handler: nil))
    present(alertController)
  }

  func confirm(_ message: String, callback: @escaping ()->Void) {
    let title = t("alert.confirm")
    confirm(title, message, callback)
  }

  func dismiss(_ animated: Bool = true) {
    dismiss(animated: animated, completion: nil)
  }

  func dismissAfter(_ delay: Double) {
    asyncAfter(delay) { self.dismiss() }
  }

  func asyncAfter(_ delay: Double, _ callback: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      callback()
    }
  }

  func async(_ callback: @escaping ()->Void) {
    asyncAfter(0, callback)
  }

  func goBack(_ animated: Bool = true) {
    navigationController!.popViewController(animated: animated)
  }

  func goBack(_ n: Int, _ animated: Bool = true) {
    let controllers = navigationController!.viewControllers
    var index = controllers.count - n - 1
    if index < 0 { index = 0 }
    navigationController!.popToViewController(controllers[index], animated: animated)
  }

  func goToRoot(_ animated: Bool = true) {
    navigationController!.popToRootViewController(animated: animated)
  }

  func hideNav() {
    navigationController!.isNavigationBarHidden = true
  }

  func showNav() {
    navigationController!.isNavigationBarHidden = false
  }

  func hideStatusBar() {
    UIApplication.shared.keyWindow!.windowLevel = UIWindow.Level.statusBar
  }

  func showStatusBar() {
    UIApplication.shared.keyWindow!.windowLevel = UIWindow.Level.normal
  }

  func instantiate<T:UIViewController>(_ type: T.Type) -> T {
    return storyboard!.instantiateViewController(withIdentifier: S(T.self)) as! T
  }

  func present(_ controller: UIViewController, _ animated: Bool = true) {
    present(controller, animated: animated, completion: nil)
  }

  func presentOverCurrentContext(_ controller: UIViewController, _ animated: Bool = true) {
    controller.modalPresentationStyle = .overCurrentContext
    present(controller, animated)
  }

  func performSegue(_ id: String) {
    performSegue(withIdentifier: id, sender: self)
  }

  func pushToNav(_ newController: UIViewController, _ animated: Bool = true) {
    navigationController!.pushViewController(newController, animated: animated)
  }

  func setNavControllers(_ controllers: [UIViewController], _ animated: Bool = true) {
    navigationController!.setViewControllers(controllers, animated: animated)
  }

  func replaceCurrentInNav(_ newController: UIViewController, _ animated: Bool = true) {
    var controllers = navigationController!.viewControllers
    controllers[controllers.count - 1] = newController
    navigationController!.setViewControllers(controllers, animated: animated)
  }

  func showSplitViewDetail(_ controller: UIViewController) {
    splitViewController!.showDetailViewController(controller, sender: self)
  }
}

extension UIPageViewController {
  func goToPreviousPage(_ animated: Bool = true, completion: (()->Void)? = nil) {
    guard let currentController = viewControllers?[0] else { return }
    guard let newController = dataSource?.pageViewController(self, viewControllerBefore: currentController) else { return }

    setViewControllers([newController], direction: .reverse, animated: true) { finished in
      if finished { completion?() }
    }
  }

  func goToNextPage(_ animated: Bool = true, completion: (()->Void)? = nil) {
    guard let currentController = viewControllers?[0] else { return }
    guard let newController = dataSource?.pageViewController(self, viewControllerAfter: currentController) else { return }

    setViewControllers([newController], direction: .forward, animated: true) { finished in
      if finished { completion?() }
    }
  }
}
