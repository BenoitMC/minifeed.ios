import Foundation

class EntriesRepository : Repository {
  var type       : EntryFilterTypes = .unread
  var categoryId : String?
  var feedId     : String?
  var q          : String?

  var entries : [Entry] = []

  var params : [String:String] {
    return [
      "type"        : type.rawValue,
      "category_id" : categoryId ?? "",
      "feed_id"     : feedId ?? "",
      "q"           : q ?? "",
    ]
  }

  func request() -> ApiRequest {
    return ApiRequest.get("/api/v1/entries", params).onSuccess {
      self.entries = $0.json["entries"].arrayValue.map { Entry($0) }
      self.onChange?()
    }
  }
}
