import XCTest
@testable import minifeed

class NavTests : TestCase {
  func testParseNav() {
    let json = readJsonFixture("nav")
    let nav  = Nav(json["nav"])

    XCTAssertEqual(nav.specialCategories.count, 2)

    XCTAssertEqual(nav.specialCategories[0].type, .unread)
    XCTAssertEqual(nav.specialCategories[0].name, "All entries")
    XCTAssertEqual(nav.specialCategories[0].counter, 12)
    XCTAssertEqual(nav.specialCategories[1].type, .starred)
    XCTAssertEqual(nav.specialCategories[1].name, "Starred")
    XCTAssertEqual(nav.specialCategories[1].counter, 5)

    XCTAssertEqual(nav.categories.count, 2)

    XCTAssertEqual(nav.categories[0].id, "category1_id")
    XCTAssertEqual(nav.categories[0].name, "My first category")
    XCTAssertEqual(nav.categories[0].counter, 9)
    XCTAssertEqual(nav.categories[0].feeds.count, 2)
    XCTAssertEqual(nav.categories[0].feeds[0].id, "feed1.1_id")
    XCTAssertEqual(nav.categories[0].feeds[0].id, "feed1.1_id")
    XCTAssertEqual(nav.categories[0].feeds[0].counter, 3)
    XCTAssertEqual(nav.categories[0].feeds[1].id, "feed1.2_id")
    XCTAssertEqual(nav.categories[0].feeds[1].id, "feed1.2_id")
    XCTAssertEqual(nav.categories[0].feeds[1].counter, 6)

    XCTAssertEqual(nav.categories[1].id, "category2_id")
    XCTAssertEqual(nav.categories[1].name, "My second category")
    XCTAssertEqual(nav.categories[1].counter, 3)
    XCTAssertEqual(nav.categories[1].feeds.count, 1)
    XCTAssertEqual(nav.categories[1].feeds[0].id, "feed2.1_id")
    XCTAssertEqual(nav.categories[1].feeds[0].id, "feed2.1_id")
    XCTAssertEqual(nav.categories[1].feeds[0].counter, 3)

    XCTAssertTrue(true)
  }
}
