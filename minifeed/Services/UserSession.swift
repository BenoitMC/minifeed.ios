import Foundation

class UserSession {
  func signin(_ baseUrl: String, _ email: String, _ password: String, _ callback: @escaping (String?)->Void) {
    guard let url = URL(string: baseUrl)?.appendingPathComponent("/api/v1/user_sessions").absoluteString else {
      callback(nil)
      return
    }

    let params = ["email" : email, "password" : password]

    ApiRequest
      .post(url, params)
      .onResponse { r in callback(r.json["current_user"]["auth_token"].string) }
      .perform()
  }
}
