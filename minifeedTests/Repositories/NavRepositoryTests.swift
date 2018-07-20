import XCTest
import Mockingjay

@testable import minifeed

class NavRepositoryTests : TestCase {
  func test_request_should_parse_response() {
    stubWithFixture("nav")

    let repository = NavRepository()

    asyncExpectation { e in
      repository.onChange { e.fulfill() }.request().perform()
    }

    XCTAssertNotNil(repository.nav)
    XCTAssertEqual(repository.nav!.categories.count, 2)
    XCTAssertEqual(repository.nav!.categories[0].name, "My first category")
  }
}
