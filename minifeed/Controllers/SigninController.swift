import Foundation
import UIKit

class SigninController : Controller {
  @IBOutlet weak var url      : UITextField!
  @IBOutlet weak var email    : UITextField!
  @IBOutlet weak var password : UITextField!
  @IBOutlet weak var submit   : UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    i18n()
  }

  func i18n() {
    url.placeholder      = t("signin.url")
    email.placeholder    = t("signin.email")
    password.placeholder = t("signin.password")
    submit.setTitleForAllStates(t("signin.submit"))
  }

  @IBAction func tapOnSubmit() {
    guard let url = url.text, let email = email.text, let password = password.text else {
      return
    }

    Flash.progress()

    UserSession().signin(url, email, password) { response in
      switch response {
      case .success(let token):
        Preferences.set("api_url", url)
        Preferences.set("auth_token", token)
        ApiRequest.baseUrl = url
        ApiRequest.defaultHeaders["Authorization"] = "Bearer " + token
        HomeController.instance?.reloadDataSilently()
        Flash.success {
          self.dismiss()
        }

      case .error(let message):
        Flash.error(message)
      }
    }
  }
}
