import Foundation
import SVProgressHUD

enum Flash {
  static func setup() {
    SVProgressHUD.setBackgroundColor(.black)
    SVProgressHUD.setForegroundColor(.white)
    SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
    SVProgressHUD.setDefaultMaskType(.black)
  }

  static func progress() {
    SVProgressHUD.show()
  }

  static func success(_ message: String? = nil, _ callback: (()->Void)? = nil) {
    SVProgressHUD.showSuccess(withStatus: message)
    SVProgressHUD.dismiss(withDelay: 1.5, completion: callback)
  }

  static func error(_ message: String? = "Error", _ callback: (()->Void)? = nil) {
    SVProgressHUD.showError(withStatus: message)
    SVProgressHUD.dismiss(withDelay: 1.5, completion: callback)
  }

  static func close() {
    SVProgressHUD.dismiss()
  }
}
