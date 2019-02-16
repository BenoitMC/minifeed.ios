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

  func instantiate<T:UIViewController>(_ type: T.Type) -> T {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: S(T.self)) as! T
  }

  func present(_ controller: UIViewController, _ animated: Bool = true) {
    present(controller, animated: animated, completion: nil)
  }

  func pushToNav(_ newController: UIViewController, _ animated: Bool = true) {
    navigationController!.pushViewController(newController, animated: animated)
  }

  func showSplitViewDetail(_ controller: UIViewController) {
    splitViewController!.showDetailViewController(controller, sender: self)
  }

  func hideKeyboad() {
    view.endEditing(true)
  }
}

