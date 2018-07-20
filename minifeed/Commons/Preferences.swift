import Foundation

enum Preferences {
  private static let s = UserDefaults.standard

  static func get(_ key: String) -> String? {
    return s.string(forKey: key)?.presence
  }

  static func set(_ key: String, _ value: String) {
    s.set(value, forKey: key)
    s.synchronize()
  }

  static func clear() {
    let domain = Bundle.main.bundleIdentifier!
    s.removePersistentDomain(forName: domain)
    s.synchronize()
  }
}
