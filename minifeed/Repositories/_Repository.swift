import Foundation

class Repository {
  typealias Callback = (() -> Void)

  var onChange : Callback? = nil

  func onChange(_ callback: @escaping Callback) -> Self {
    self.onChange = callback
    return self
  }
}
