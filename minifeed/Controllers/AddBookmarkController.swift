import Foundation
import UIKit

enum AddBookmarkController  {
  static func build(done: @escaping () -> Void) -> UIAlertController{
    let alert = UIAlertController(title: t("add_bookmark.title"), message: nil, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: t("add_bookmark.cancel"), style: .cancel, handler: nil))

    alert.addAction(UIAlertAction(title: t("add_bookmark.add"), style: .default) { _ in
      guard let url = alert.textFields?[0].text else {
        done()
        return
      }

      Flash.progress()

      EntryCreateRepository(url).request()
        .onSuccess { _ in Flash.success() }
        .onError { _ in Flash.error() }
        .onResponse { _ in done() }
        .perform()
    })

    var text: String?
    if UIPasteboard.general.string?.starts(with: "http") ?? false { text = UIPasteboard.general.string }
    alert.addTextField(text: text, placeholder: t("add_bookmark.url"), editingChangedTarget: nil, editingChangedSelector: nil)
    alert.textFields?.first?.clearButtonMode = .always

    return alert
  }
}
