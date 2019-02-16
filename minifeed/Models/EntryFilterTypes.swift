import Foundation

enum EntryFilterTypes : String {
  case all, unread, starred

  static var allCases : [EntryFilterTypes] {
    return [.all, .unread, .starred]
  }

  static var names : [String] = {
    allCases.map { t("entry_filter_types.\($0.rawValue)") }
  }()
}
