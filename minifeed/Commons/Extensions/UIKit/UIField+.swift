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
    let field = UITextField.stylized()
    field.textContentType = .URL
    field.keyboardType = .URL
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.spellCheckingType = .no
    field.placeholder = placeholder
    return field
  }

  static func forEmail(placeholder: String? = nil) -> UITextField {
    let field = UITextField.stylized()
    field.textContentType = .emailAddress
    field.keyboardType = .emailAddress
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.spellCheckingType = .no
    field.placeholder = placeholder
    return field
  }

  static func forPassword(placeholder: String? = nil) -> UITextField {
    let field = UITextField.stylized()
    field.isSecureTextEntry = true
    field.textContentType = .password
    field.keyboardType = .asciiCapable
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.spellCheckingType = .no
    field.placeholder = placeholder
    return field
  }
}