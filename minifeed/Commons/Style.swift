import Foundation
import UIKit

enum Style {
  static func applyCommons() {
    let navbarAppearance = UINavigationBarAppearance()
    navbarAppearance.configureWithOpaqueBackground()
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().standardAppearance = navbarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navbarAppearance

    let toolbarAppearance = UIToolbarAppearance()
    toolbarAppearance.configureWithOpaqueBackground()
    UIToolbar.appearance().isTranslucent = false
    UIToolbar.appearance().standardAppearance = toolbarAppearance
    if #available(iOS 15.0, *) {
      UIToolbar.appearance().scrollEdgeAppearance = toolbarAppearance
    }
  }
}
