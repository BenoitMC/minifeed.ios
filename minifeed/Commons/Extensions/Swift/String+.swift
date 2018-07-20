import Foundation
import SwifterSwift

extension String {
  var isBlank : Bool {
    return trimmed == ""
  }

  var isPresent : Bool {
    return !isBlank
  }

  var presence : String? {
    return isPresent ? self : nil
  }
}
