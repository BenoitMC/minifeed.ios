import Foundation
import UIKit
import WebKit
import SnapKit
import SafariServices

class EntryDetailsController : Controller {
  @IBOutlet weak var label            : UILabel!
  @IBOutlet weak var infos            : UILabel!
  @IBOutlet weak var webviewContainer : UIView!

  let webview = WKWebView()

  var entry: Entry!

  override func viewDidLoad() {
    super.viewDidLoad()

    webviewContainer.addSubview(webview)
    webview.snp.makeConstraints { $0.edges.equalTo(webviewContainer) }
    webview.loadHTMLString(entry.bodyHTML, baseURL: entry.url?.url)

    updateViews()
  }

  func updateViews() {
    label.text = entry.name
    infos.text = entry.infos
  }
}


