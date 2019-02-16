import Foundation
import UIKit

class Controller : UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError() }
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
