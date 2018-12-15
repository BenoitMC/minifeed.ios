import XCTest
import Mockingjay

@testable import minifeed

class EntriesRepositoryTests : TestCase {
  func test_request_should_parse_response() {
    stubWithFixture("entries")

    let repository = EntriesRepository()

    asyncExpectation { e in
      repository.onChange { e.fulfill() }.request().perform()
    }

    XCTAssertEqual(repository.entries.count, 2)
    XCTAssertEqual(repository.entries[0].name, "Entry 1 name")
    XCTAssertEqual(repository.entries[1].name, "Entry 2 name")
  }

  func test_default_type_is_unread() {
    XCTAssertEqual(EntriesRepository().type, .unread)
  }

  func test_request_should_add_query_params() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "GET")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries")
      XCTAssertEqual(request.url!.query, "category_id=cid&feed_id=fid&q=search&type=starred")
    }

    let repository = EntriesRepository()
    repository.type       = .starred
    repository.categoryId = "cid"
    repository.feedId     = "fid"
    repository.q          = "search"

    asyncExpectation { e in
      repository.onChange { e.fulfill() }.request().perform()
    }
  }
}
