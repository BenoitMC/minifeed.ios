import XCTest
import SwiftyJSON
import Mockingjay
import RxSwift

@testable import minifeed

class TestCase : XCTestCase {
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func readFixture(_ id: String) -> String {
    return readDataFixture(id).string!
  }

  func readDataFixture(_ id: String) -> Data {
    let bundle = Bundle(for: type(of: self))
    let url    = bundle.url(forResource: id, withExtension: "json")!
    let data   = try! Data(contentsOf: url)

    return data
  }

  func readJsonFixture(_ id: String) -> JSON {
    return JSON(parseJSON: readFixture(id))
  }

  func asyncExpectation(_ description: String = "", callback: (XCTestExpectation) -> Void) {
    let expectation = self.expectation(description: description)
    callback(expectation)
    waitForExpectations(timeout: 10.0)
  }

  func stubWithFixture(_ id: String) {
    stub(everything, jsonData(readDataFixture(id)))
  }

  func testRequest(_ callback: @escaping (URLRequest) -> Void) {
    let matcher = { (request: URLRequest) -> Bool in
      callback(request)
      return true
    }
    stub(matcher, json([:]))
  }

  let disposeBag = DisposeBag()
}
