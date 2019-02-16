import Foundation
import UIKit
import WebKit
import SnapKit
import SafariServices

class EntryDetailsController : Controller {
  init(entry: Entry, navigationDelegate: WKNavigationDelegate) {
    self.entry = entry
    webview.navigationDelegate = navigationDelegate

    super.init()

    makeViews()
    makeConstraints()
  }

  required init?(coder: NSCoder) { fatalError() }

  var entry: Entry

  private let stack = UIStackView().do {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .fill
    $0.spacing = 5
  }

  private let label = UILabel().do {
    $0.font = UIFont.boldSystemFont(ofSize: 22)
  }

  private let infos = UILabel().do {
    $0.font = $0.font.withSize(17)
    $0.textColor = .gray
  }

  let webview = WKWebView()

  private func makeViews() {
    view.addSubview(stack)
    stack.addArrangedSubview(label)
    stack.addArrangedSubview(infos)
    stack.addArrangedSubview(webview)
  }

  private func makeConstraints() {
    stack.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(10)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webview.loadHTMLString(entry.bodyHTML, baseURL: entry.url?.url)
    updateViews()
  }

  private func updateViews() {
    label.text = entry.name
    infos.text = entry.infos
  }
}


