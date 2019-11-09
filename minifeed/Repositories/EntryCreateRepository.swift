import Foundation

class EntryCreateRepository {
  private var url: String

  init(_ url: String) {
    self.url = url
  }

  func request() -> ApiRequest {
    ApiRequest.post("/api/v1/entries", ["url": url])
  }
}
