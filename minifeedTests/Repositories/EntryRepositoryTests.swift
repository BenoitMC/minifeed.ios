import XCTest
import Mockingjay

@testable import minifeed

class EntryRepositoryTests : TestCase {
  lazy var entry : Entry = {
    let entry = Entry()
    entry.id = "123"
    entry.isRead = false
    entry.isStarred = false
    return entry
  }()

  func test_request_should_parse_response() {
    stubWithFixture("entry")

    let repository = EntryRepository(entry)

    asyncExpectation { e in
      repository.onChange { e.fulfill() }.toggleReadRequest().perform()
    }

    XCTAssertEqual(repository.entry.name, "Entry name")
    XCTAssertEqual(repository.entry.isRead, true)
  }

  func test_toggle_read_request() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "PATCH")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries/123")
      XCTAssertEqual(request.httpBodyStringDecoded, "entry[is_read]=1")
    }

    asyncExpectation { e in
      EntryRepository(entry).onChange { e.fulfill() }.toggleReadRequest().perform()
    }
  }

  func test_toggle_starred_request() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "PATCH")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries/123")
      XCTAssertEqual(request.httpBodyStringDecoded, "entry[is_starred]=1")
    }

    asyncExpectation { e in
      EntryRepository(entry).onChange { e.fulfill() }.toggleStarredRequest().perform()
    }
  }
}
