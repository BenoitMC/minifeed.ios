import Foundation

extension String {
  var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var isBlank : Bool {
    return trimmed == ""
  }

  var isPresent : Bool {
    return !isBlank
  }

  var presence : String? {
    return isPresent ? self : nil
  }

  var url: URL? {
    return URL(string: self)
  }

  var urlDecoded: String {
    return removingPercentEncoding ?? self
  }
}
