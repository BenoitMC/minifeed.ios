import Foundation
import SwiftyJSON

class Model {
  var id: String?

  init() {}

  init(_ json: JSON) {
    loadFromJson(json)
  }

  func loadFromJson(_ json: JSON) {
  }
}

extension Model : Equatable {
  static func == (lhs: Model, rhs: Model) -> Bool {
    guard lhs.id != nil && rhs.id != nil else { return false }
    return lhs.id == rhs.id
  }
}
