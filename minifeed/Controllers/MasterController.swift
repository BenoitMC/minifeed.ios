import Foundation
import UIKit

class MasterController : UISplitViewController {
  init () {
    super.init(nibName: nil, bundle: nil)

    preferredDisplayMode = .oneBesideSecondary
    loadPreferences()
    navController.setViewControllers([homeController])
    hideDetailControllerIfNeeded()
    homeController.reloadData()
  }

  required init?(coder: NSCoder) { fatalError() }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if !isSignedIn {
      present(SigninController())
    }
  }

  private let navController = UINavigationController()

  private let homeController = HomeController()

  func hideDetailControllerIfNeeded() {
    if UIDevice.current.userInterfaceIdiom == .pad {
      let blankViewController = UIViewController().do {
        $0.view.backgroundColor = .white
      }
      
      viewControllers = [navController, blankViewController]
    } else {
      viewControllers = [navController]
    }
  }

  private func loadPreferences() {
    guard isSignedIn else { return }

    ApiRequest.baseUrl = Preferences.get("api_url")!
    ApiRequest.defaultHeaders["Authorization"] = "Bearer " + Preferences.get("auth_token")!
  }

  func signOut() {
    navController.popToRootViewController(animated: false)
    Preferences.clear()
    present(SigninController())
  }
}
