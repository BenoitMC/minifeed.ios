import Foundation
import UIKit

extension UITextField {
  static func stylized() -> UITextField {
    let field = UITextField()
    field.backgroundColor = .white
    field.borderStyle = .roundedRect
    return field
  }

  static func forURL(placeholder: String? = nil) -> UITextField {
    return UITextField.stylized().do {
      $0.textContentType = .URL
      $0.keyboardType = .URL
      $0.autocapitalizationType = .none
      $0.autocorrectionType = .no
      $0.spellCheckingType = .no
      $0.placeholder = placeholder
    }
  }

  static func forEmail(placeholder: String? = nil) -> UITextField {
    return UITextField.stylized().do {
      $0.textContentType = .emailAddress
      $0.keyboardType = .emailAddress
      $0.autocapitalizationType = .none
      $0.autocorrectionType = .no
      $0.spellCheckingType = .no
      $0.placeholder = placeholder
    }
  }

  static func forPassword(placeholder: String? = nil) -> UITextField {
    return UITextField.stylized().do {
      $0.isSecureTextEntry = true
      $0.textContentType = .password
      $0.keyboardType = .asciiCapable
      $0.autocapitalizationType = .none
      $0.autocorrectionType = .no
      $0.spellCheckingType = .no
      $0.placeholder = placeholder
    }
  }
}
