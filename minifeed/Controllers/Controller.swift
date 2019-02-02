import Foundation
import UIKit

class Controller : UIViewController {
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
