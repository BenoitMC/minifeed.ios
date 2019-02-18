import Foundation
import Alamofire
import RxSwift

class EntriesRepository {
  var type       : EntryFilterTypes = .unread
  var categoryId : String?
  var feedId     : String?
  var q          : String?

  private let entriesPublish = PublishSubject<[Entry]>()

  lazy var entriesObservable = entriesPublish.asObservable()

  var params : [String:String] {
    return [
      "type"        : type.rawValue,
      "category_id" : categoryId ?? "",
      "feed_id"     : feedId ?? "",
      "q"           : q ?? "",
    ]
  }

  func get() -> ApiRequest {
    return commonRequest(.get, "/api/v1/entries")
  }

  func markAllAsRead() -> ApiRequest{
    return commonRequest(.post, "/api/v1/entries/mark-all-as-read")
  }

  private func commonRequest(_ method: HTTPMethod, _ url: String) -> ApiRequest {
    return ApiRequest(method, url, params).onSuccess {
      let entries = $0.json["entries"].arrayValue.map { Entry($0) }
      self.entriesPublish.onNext(entries)
    }
  }
}
