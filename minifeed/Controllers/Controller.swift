import Foundation
import UIKit

class Controller : UIViewController {
}

extension UIViewController {
  var isSignedIn : Bool {
    return Preferences.get("api_url") != nil && Preferences.get("auth_token") != nil
  }

  func showErrorIfNeeded(_ response: ApiResponse) {
    if !response.is2xx {
      Flash.error(response.errorMessage ?? "Unknown error")
    }
  }
}
