import Foundation

extension Data {
  func string(encoding: String.Encoding) -> String? {
    return String(data: self, encoding: encoding)
  }

  var string : String? {
    return string(encoding: .utf8)
  }
}
