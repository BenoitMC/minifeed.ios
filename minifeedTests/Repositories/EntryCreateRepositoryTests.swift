import XCTest
import Mockingjay
import RxSwift

@testable import minifeed

class EntryCreateRepositoryTests : TestCase {
  func test_request() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "POST")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries")
      XCTAssertEqual(request.httpBodyString, "url=https%3A//example.org/")
    }

    let repository = EntryCreateRepository("https://example.org/")

    asyncExpectation { e in
      repository.request().onResponse { _ in e.fulfill() }.perform()
    }
  }
}
