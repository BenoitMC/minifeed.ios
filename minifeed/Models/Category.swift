import Foundation
import SwiftyJSON

class Category : Model {
  var name    : String?
  var counter : Int = 0
  var feeds   : [Feed] = []

  override func loadFromJson(_ json: JSON) {
    super.loadFromJson(json)

    id      = json["id"].stringValue
    name    = json["name"].stringValue
    counter = json["counter"].intValue
    feeds   = json["feeds"].arrayValue.map { Feed($0) }
  }
}
