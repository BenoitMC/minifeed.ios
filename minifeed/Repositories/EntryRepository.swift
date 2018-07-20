import Foundation

class EntryRepository : Repository {
  var entry: Entry

  init(_ entry: Entry) {
    self.entry = entry
  }

  var url : String {
    return "/api/v1/entries/" + entry.id!
  }

  func toggleReadRequest() -> ApiRequest {
    return update(["entry[is_read]" : !entry.isRead!])
  }

  func toggleStarredRequest() -> ApiRequest {
    return update(["entry[is_starred]" : !entry.isStarred!])
  }

  private func update(_ params: [String:Any]) -> ApiRequest {
    return ApiRequest.patch(url, params).onSuccess {
      self.entry.loadFromJson($0.json["entry"])
      self.onChange?()
    }
  }
}
