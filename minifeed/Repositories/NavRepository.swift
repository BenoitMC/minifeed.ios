import Foundation
import RxSwift

class NavRepository {
  private init() {}

  static let instance = NavRepository()

  private let navBehavior = BehaviorSubject<Nav>(value: Nav())

  lazy var navObservable = navBehavior.asObservable()

  func request() -> ApiRequest {
    return ApiRequest.get("/api/v1").onSuccess {
      let nav = Nav($0.json["nav"])
      self.navBehavior.onNext(nav)
    }
  }

  func reload() {
    request().perform()
  }
}
