import Foundation

func S(_ obj: Any?) -> String {
  return String(describing: obj ?? "")
}

func t(_ key: String, _ attributes: [String: Any?] = [:]) -> String {
  var str = NSLocalizedString(key, comment: key)

  for (k, v) in attributes {
    str = str.replacingOccurrences(of: "{\(k)}", with: S(v))
  }

  return str
}
