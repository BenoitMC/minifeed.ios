import XCTest
import Mockingjay
import RxSwift

@testable import minifeed

class EntryRepositoryTests : TestCase {
  lazy var entry : Entry = {
    let entry = Entry()
    entry.id = "123"
    entry.isRead = false
    entry.isStarred = false
    return entry
  }()

  lazy var repository : EntryRepository = {
    return EntryRepository(entry)
  }()

  func test_request_should_parse_response() {
    stubWithFixture("entry")

    asyncExpectation { e in
      repository.entryObservable.subscribe(onNext: { _ in e.fulfill() }).disposed(by: disposeBag)
      repository.toggleReadRequest().perform()
    }

    XCTAssertEqual(entry.name, "Entry name")
    XCTAssertEqual(entry.isRead, true)
  }

  func test_toggle_read_request() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "PATCH")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries/123")
      XCTAssertEqual(request.httpBodyStringDecoded, "entry[is_read]=1")
    }

    asyncExpectation { e in
      repository.entryObservable.subscribe(onNext: { _ in e.fulfill() }).disposed(by: disposeBag)
      repository.toggleReadRequest().perform()
    }
  }

  func test_toggle_starred_request() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "PATCH")
      XCTAssertEqual(request.url!.relativePath, "/api/v1/entries/123")
      XCTAssertEqual(request.httpBodyStringDecoded, "entry[is_starred]=1")
    }

    asyncExpectation { e in
      repository.entryObservable.subscribe(onNext: { _ in e.fulfill() }).disposed(by: disposeBag)
      repository.toggleStarredRequest().perform()
    }
  }
}
