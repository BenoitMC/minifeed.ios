import XCTest
import Mockingjay
import RxSwift

@testable import minifeed

class EntriesRepositoryTests : TestCase {
  func test_default_type_is_unread() {
    XCTAssertEqual(EntriesRepository().type, .unread)
  }

  func test_get_request_should_parse_response() {
    stubWithFixture("entries")

    let repository = EntriesRepository()
    var result : EntriesRepository.Result?

    asyncExpectation { e in
      repository.entriesObservable.subscribe(onNext: { result = $0 }).disposed(by: disposeBag)
      repository.get().onResponse { _ in e.fulfill() }.perform()
    }

    XCTAssertNotNil(result)
    XCTAssertFalse(result!.isLastPage)
    XCTAssertEqual(result!.entries.count, 2)
    XCTAssertEqual(result!.entries[0].name, "Entry 1 name")
    XCTAssertEqual(result!.entries[1].name, "Entry 2 name")
  }

  func test_get_request_should_add_query_params() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "GET")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries")
      XCTAssertEqual(request.url!.query, "category_id=cid&feed_id=fid&page=1&q=search&type=starred")
    }

    let repository = EntriesRepository()
    repository.type       = .starred
    repository.categoryId = "cid"
    repository.feedId     = "fid"
    repository.q          = "search"

    asyncExpectation { e in
      repository.get().onResponse { _ in e.fulfill() }.perform()
    }
  }

  func test_mark_all_as_read_request_should_add_query_params() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "POST")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries/mark-all-as-read")
      XCTAssertEqual(request.httpBodyString, "category_id=cid&feed_id=fid&page=1&q=search&type=starred")
    }

    let repository = EntriesRepository()
    repository.type       = .starred
    repository.categoryId = "cid"
    repository.feedId     = "fid"
    repository.q          = "search"

    asyncExpectation { e in
      repository.markAllAsRead().onResponse { _ in e.fulfill() }.perform()
    }
  }
}
