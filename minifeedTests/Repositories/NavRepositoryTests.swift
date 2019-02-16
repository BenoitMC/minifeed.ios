import XCTest
import Mockingjay
import RxSwift

@testable import minifeed

class NavRepositoryTests : TestCase {
  func test_request_should_parse_response() {
    stubWithFixture("nav")

    let repository = NavRepository.instance
    var nav: Nav?

    asyncExpectation { e in
      repository.navObservable.subscribe(onNext: { nav = $0 }).disposed(by: disposeBag)
      repository.request().onResponse({ _ in e.fulfill() }).perform()
    }

    XCTAssertNotNil(nav)
    XCTAssertEqual(nav!.categories.count, 2)
    XCTAssertEqual(nav!.categories[0].name, "My first category")
  }
}
