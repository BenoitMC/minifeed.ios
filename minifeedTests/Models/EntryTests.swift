import XCTest
@testable import minifeed

class EntryTests : TestCase {
  func testParseEntries() {
    let json = readJsonFixture("entries")

    let entry1 = Entry(json["entries"][0])
    XCTAssertEqual(entry1.id, "Entry 1 id")
    XCTAssertEqual(entry1.name, "Entry 1 name")
    XCTAssertEqual(entry1.body, "Entry 1 body")
    XCTAssertEqual(entry1.categoryName, "Entry 1 category name")
    XCTAssertEqual(entry1.feedName, "Entry 1 feed name")
    XCTAssertEqual(entry1.isRead, true)
    XCTAssertEqual(entry1.isStarred, true)
    XCTAssertEqual(entry1.publishedAtHuman, "10 minutes")
    XCTAssertEqual(entry1.url, "https://example.org/1")

    let entry2 = Entry(json["entries"][1])
    XCTAssertEqual(entry2.id, "Entry 2 id")
    XCTAssertEqual(entry2.name, "Entry 2 name")
    XCTAssertEqual(entry2.body, "Entry 2 body")
    XCTAssertEqual(entry2.categoryName, "Entry 2 category name")
    XCTAssertEqual(entry2.feedName, "Entry 2 feed name")
    XCTAssertEqual(entry2.isRead, false)
    XCTAssertEqual(entry2.isStarred, false)
    XCTAssertEqual(entry2.publishedAtHuman, "2 hours")
    XCTAssertEqual(entry2.url, "https://example.org/2")
  }
}
