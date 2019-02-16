import Foundation
import UIKit

class Controller : UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    hideBackButtonText()
  }

  required init?(coder: NSCoder) { fatalError() }

  private func hideBackButtonText() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}

extension UIViewController {
  var isSignedIn : Bool {
    return UserSession.isSignedIn
  }

  func showErrorIfNeeded(_ response: ApiResponse) {
    if !response.is2xx {
      Flash.error(response.errorMessage ?? "Unknown error")
    }
  }
}
