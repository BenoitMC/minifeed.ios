import Foundation
import SwiftyJSON

class Feed : Model {
  var name    : String?
  var counter : Int = 0

  override func loadFromJson(_ json: JSON) {
    super.loadFromJson(json)

    id      = json["id"].stringValue
    name    = json["name"].stringValue
    counter = json["counter"].intValue
  }
}
