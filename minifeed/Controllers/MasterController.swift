import Foundation
import UIKit

class MasterController : UISplitViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    hideDetailController()
    loadPreferences()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if !isSignedIn {
      present(instantiate(SigninController.self))
    }
  }

  func hideDetailController() {
    if UIDevice.current.userInterfaceIdiom == .pad {
      let blank = UIViewController()
      blank.view.backgroundColor = .white
      viewControllers = [viewControllers.first!, blank]
    } else {
      viewControllers = [viewControllers.first!]
    }
  }

  func loadPreferences() {
    guard isSignedIn else { return }

    ApiRequest.baseUrl = Preferences.get("api_url")!
    ApiRequest.defaultHeaders["X-Auth-Token"] = Preferences.get("auth_token")!
  }

  func signout() {
    Preferences.clear()
    present(instantiate(SigninController.self))
  }
}
