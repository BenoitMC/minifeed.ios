import Foundation
import UIKit
import SnapKit
import SwifterSwift

class SigninController : Controller {
  override init() {
    super.init()

    modalPresentationStyle = .overFullScreen

    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private let mainStack = UIStackView().do {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .center
    $0.spacing = 50
  }

  private let logo = UIImageView(image: UIImage.find("icon"))

  private let formStack = UIStackView().do {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .fill
    $0.spacing = 20
  }

  private let url      = UITextField.forURL(placeholder: t("signin.url"))
  private let email    = UITextField.forEmail(placeholder: t("signin.email"))
  private let password = UITextField.forPassword(placeholder: t("signin.password"))
  private let submit   = UIButton(title: t("signin.submit"))

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
    guard
      let url = url.text?.trimmed.presence,
      let email = email.text?.trimmed.presence,
      let password = password.text?.trimmed.presence
    else {
      alert(t("signin.missing_info"))
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
        NavRepository.instance.reload()
        self.dismiss()

      case .error(let message):
        Flash.error(message)
      }
    }
  }
}
