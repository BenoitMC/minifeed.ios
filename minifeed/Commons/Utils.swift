import Foundation

enum Utils {
  static var appVersion: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  }
}
