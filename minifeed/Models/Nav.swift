import Foundation
import SwiftyJSON

class Nav : Model {
  var categories        : [Category] = []
  var specialCategories : [SpecialCategory] = []

  override func loadFromJson(_ json: JSON) {
    super.loadFromJson(json)

    categories        = json["categories"].arrayValue.map { Category($0) }
    specialCategories = []
    specialCategories.append(SpecialCategory(.unread,  json["unread"]["name"].stringValue,  json["unread"]["counter"].intValue))
    specialCategories.append(SpecialCategory(.starred, json["starred"]["name"].stringValue, json["starred"]["counter"].intValue))
  }

  class SpecialCategory {
    var type    : EntryFilterTypes
    var name    : String
    var counter : Int

    init(_ type: EntryFilterTypes, _ name: String, _ counter: Int) {
      self.type    = type
      self.name    = name
      self.counter = counter
    }
  }
}
