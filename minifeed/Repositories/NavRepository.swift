import Foundation

class NavRepository : Repository {
  var nav : Nav?

  func request() -> ApiRequest {
    return ApiRequest.get("/api/v1").onSuccess {
      self.nav = Nav($0.json["nav"])
      self.onChange?()
    }
  }
}
