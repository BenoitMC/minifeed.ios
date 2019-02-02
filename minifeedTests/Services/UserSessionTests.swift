import XCTest
import Mockingjay

@testable import minifeed

class UserSessionTests : TestCase {
  func test_signin_ok() {
    stubWithFixture("signin.ok")

    asyncExpectation { e in
      UserSession().signin("https://example.org/", "", "") { response in
        XCTAssertEqual(response, UserSession.Response.success(token: "my_auth_token"))
        e.fulfill()
      }
    }
  }

  func test_signin_ko() {
    stubWithFixture("signin.ko")

    asyncExpectation { e in
      UserSession().signin("https://example.org/", "", "") { response in
        XCTAssertEqual(response, UserSession.Response.error(message: "Invalid email and/or password."))
        e.fulfill()
      }
    }
  }

  func test_signin_invalid_url() {
    stubWithFixture("signin.invalid")

    asyncExpectation { e in
      UserSession().signin("", "", "") { response in
        XCTAssertEqual(response, UserSession.Response.error(message: "URL is invalid."))
        e.fulfill()
      }
    }
  }

  func test_signin_invalid() {
    stubWithFixture("signin.invalid")

    asyncExpectation { e in
      UserSession().signin("https://example.org/", "", "") { response in
        XCTAssertEqual(response, UserSession.Response.error(message: nil))
        e.fulfill()
      }
    }
  }

  func test_signin_request() {
    testRequest { request in
      XCTAssertEqual(request.httpMethod, "POST")
      XCTAssertEqual(request.url!.absoluteString, "https://example.org/api/v1/user_sessions")
      XCTAssertEqual(request.httpBodyStringDecoded, "email=a&password=b")
    }

    asyncExpectation { e in
      UserSession().signin("https://example.org", "a", "b") { _ in e.fulfill() }
    }
  }
}
