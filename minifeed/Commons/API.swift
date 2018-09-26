import Foundation
import Alamofire
import SwiftyJSON

class ApiRequest {
  typealias Params  = Parameters
  typealias Headers = HTTPHeaders

  static var baseUrl        = "http://localhost"
  static var defaultHeaders = Headers()

  var method   : HTTPMethod
  var url      : URLConvertible
  var params   : Params?
  var encoding : ParameterEncoding
  var headers  : Headers

  required init(
    _ method   : HTTPMethod,
    _ path     : String,
    _ params   : Params? = nil,
    _ encoding : ParameterEncoding? = nil,
    _ headers  : Headers? = nil
  ) {
    self.method = method

    if path.starts(with: "http") {
      self.url = URL(string: path)!
    } else {
      self.url = URL(string: ApiRequest.baseUrl)!.appendingPathComponent(path)
    }

    self.params   = params
    self.headers  = headers ?? ApiRequest.defaultHeaders
    self.encoding = encoding ?? URLEncoding.methodDependent
  }

  static func get(_ url: String, _ params: Params? = nil, _ headers: Headers? = nil) -> Self {
    return self.init(.get, url, params, nil, headers)
  }

  static func post(_ url: String, _ params: Params? = nil, _ headers: Headers? = nil) -> Self {
    return self.init(.post, url, params, nil, headers)
  }

  static func patch(_ url: String, _ params: Params? = nil, _ headers: Headers? = nil) -> Self {
    return self.init(.patch, url, params, nil, headers)
  }

  static func put(_ url: String, _ params: Params? = nil, _ headers: Headers? = nil) -> Self {
    return self.init(.put, url, params, nil, headers)
  }

  static func delete(_ url: String, _ headers: Headers? = nil) -> Self {
    return self.init(.delete, url, nil, nil, headers)
  }

  typealias CallbacksArray = [((ApiResponse) -> Void)]

  private var onResponse : CallbacksArray = []

  func onResponse(_ callback: @escaping (ApiResponse) -> Void) -> Self {
    onResponse.append(callback)
    return self
  }

  private var onSuccess : CallbacksArray = []

  func onSuccess(_ callback: @escaping (ApiResponse) -> Void) -> Self {
    onSuccess.append(callback)
    return self
  }

  private var onClientError : CallbacksArray = []

  func onClientError(_ callback: @escaping (ApiResponse) -> Void) -> Self {
    onClientError.append(callback)
    return self
  }

  private var onOtherError : CallbacksArray = []

  func onOtherError(_ callback: @escaping (ApiResponse) -> Void) -> Self {
    onOtherError.append(callback)
    return self
  }

  private var onError : CallbacksArray = []

  func onError(_ callback: @escaping (ApiResponse) -> Void) -> Self {
    onError.append(callback)
    return self
  }

  private func runCallbacks(_ callbacks: CallbacksArray, _ response: ApiResponse) {
    for callback in callbacks {
      DispatchQueue.main.async {
        callback(response)
      }
    }
  }

  private func runCallback(_ response: ApiResponse) {
    self.runCallbacks(self.onResponse, response)

    if response.is2xx {
      self.runCallbacks(self.onSuccess, response)
      return
    }

    if response.is4xx {
      self.runCallbacks(self.onClientError, response)
    } else {
      self.runCallbacks(self.onOtherError, response)
    }

    self.runCallbacks(self.onError, response)
  }

  func perform() {
    Alamofire
      .request(url, method: method, parameters: params, encoding: encoding, headers: headers)
      .responseString { rawResponse in
        let response = ApiResponse(rawResponse)
        self.runCallback(response)
    }
  }
}

class ApiResponse {
  typealias RawResponse = Alamofire.DataResponse<String>

  private let rawResponse : RawResponse

  init(_ rawResponse: RawResponse) {
    self.rawResponse = rawResponse
  }

  var code : Int? {
    return rawResponse.response?.statusCode
  }

  var body : String? {
    return rawResponse.value
  }

  var headers : [String:String] {
    return (rawResponse.response?.allHeaderFields as? [String:String]) ?? [:]
  }

  private func isCodeIn(_ min: Int, _ max: Int) -> Bool {
    guard let code = code else { return false }
    return code >= min && code <= max
  }

  var is2xx : Bool { return isCodeIn(200, 299) }
  var is4xx : Bool { return isCodeIn(400, 499) }
  var is5xx : Bool { return isCodeIn(500, 599) }

  var systemErrorMessage : String? {
    return rawResponse.error?.localizedDescription
  }

  lazy var json : JSON = {
    JSON(parseJSON: body ?? "{}")
  }()

  lazy var jsonErrorMessage : String? = {
    if let error = json["error"].string {
      return error
    }

    let errors = json["error"].arrayValue
      .map { $0.stringValue }
      .filter { $0 != "" }

    if !errors.isEmpty {
      return errors.joined(separator: "\n")
    }

    return nil
  }()

  lazy var jsonErrorCode : String = {
    return json["error_code"].stringValue
  }()

  var errorMessage: String? {
    return systemErrorMessage ?? jsonErrorMessage
  }

  func debugRequest() {
    debugPrint("******************** REQUEST BEGIN ********************")
    debugPrint(rawResponse.request!.url as Any)
    debugPrint(rawResponse.request!.allHTTPHeaderFields as Any)
    debugPrint(rawResponse.request!.httpBody as Any)
    debugPrint("******************** REQUEST END ********************")
  }

  func debugResponse() {
    debugPrint("******************** RESPONSE BEGIN ********************")
    debugPrint(rawResponse)
    debugPrint("******************** RESPONSE END ********************")
  }

  func debug() {
    debugRequest()
    debugResponse()
  }
}
