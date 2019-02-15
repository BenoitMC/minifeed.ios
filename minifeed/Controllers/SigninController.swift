import Foundation
import UIKit
import SnapKit
import SwifterSwift

class SigninController : Controller {
  init() {
    super.init(nibName: nil, bundle: nil)
    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private var mainStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.distribution = .fill
    stack.alignment = .center
    stack.spacing = 50
    return stack
  }()

  private var logo = UIImageView(image: UIImage.find("icon"))

  private var formStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.distribution = .fill
    stack.alignment = .fill
    stack.spacing = 20
    return stack
  }()

  private var url      = UITextField.forURL(placeholder: t("signin.url"))
  private var email    = UITextField.forEmail(placeholder: t("signin.email"))
  private var password = UITextField.forPassword(placeholder: t("signin.password"))
  private var submit   = UIButton(title: t("signin.submit"))

  private func makeViews() {
    view.backgroundColor = UIColor(hex: 0x0099FF)

    view.addSubview(mainStack)

    mainStack.addArrangedSubview(logo)
    mainStack.addArrangedSubview(formStack)

    formStack.addArrangedSubview(url)
    formStack.addArrangedSubview(email)
    formStack.addArrangedSubview(password)
    formStack.addArrangedSubview(submit)
  }

  private func makeConstraints() {
    mainStack.snp.makeConstraints {
      $0.width.equalTo(280)
      $0.center.equalToSuperview()
    }

    logo.snp.makeConstraints {
      $0.size.equalTo(150)
    }

    formStack.snp.makeConstraints {
      $0.width.equalToSuperview()
    }

    for item in [url, email, password, submit] {
      item.snp.makeConstraints { $0.height.equalTo(40) }
    }
  }

  private func makeBindings() {
    submit.addTarget(self, action: #selector(tapOnSubmit), for: .touchUpInside)
  }

  @objc
  private func tapOnSubmit() {
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
