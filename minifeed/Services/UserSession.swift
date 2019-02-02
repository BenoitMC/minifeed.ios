import Foundation

class UserSession {
  enum Response: Equatable {
    case success(token: String)
    case error(message: String?)
  }

  func signin(_ baseUrl: String, _ email: String, _ password: String, _ callback: @escaping (Response)->Void) {
    guard let url = URL(string: baseUrl)?.appendingPathComponent("/api/v1/user_sessions").absoluteString else {
      callback(Response.error(message: t("signin.invalid_url")))
      return
    }

    let params = ["email" : email, "password" : password]

    ApiRequest
      .post(url, params)
      .onResponse { r in
        if let token = r.json["current_user"]["auth_token"].string {
          callback(Response.success(token: token))
        }
        else {
          callback(Response.error(message: r.errorMessage))
        }
      }
      .perform()
  }
}
