import Foundation

enum EntryFilterTypes : String {
  case all, unread, starred

  static var allCases : [EntryFilterTypes] {
    return [.all, .unread, .starred]
  }
}
