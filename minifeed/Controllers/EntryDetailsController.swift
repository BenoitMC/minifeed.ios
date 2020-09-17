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
    makeBindings()
  }

  required init?(coder: NSCoder) { fatalError() }

  var entry: Entry

  private let stack = UIStackView().do {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .center
    $0.spacing = 5
  }

  private let label = UILabel().do {
    $0.numberOfLines = 2
    $0.font = UIFont.boldSystemFont(ofSize: 22)
  }

  private let infos = UILabel().do {
    $0.font = $0.font.withSize(17)
    $0.textColor = .gray
  }

  let webview = WKWebView().do {
    $0.backgroundColor = .clear
    $0.scrollView.backgroundColor = .clear
    $0.isOpaque = false
  }

  private func makeViews() {
    view.backgroundColor = .systemBackground
    view.addSubview(stack)
    stack.addArrangedSubview(label)
    stack.addArrangedSubview(infos)
    stack.addArrangedSubview(webview)
  }

  private func makeConstraints() {
    stack.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalToSuperview().offset(10)
    }

    for element in [label, infos] {
      element.snp.makeConstraints {
        $0.width.equalToSuperview().offset(-24)
      }
    }

    webview.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
  }

  private func makeBindings() {
    let gr = UITapGestureRecognizer(target: self, action: #selector(toggleTitleLines))
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(gr)
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

  @objc
  private func toggleTitleLines() {
    label.numberOfLines = label.numberOfLines == 0 ? 2 : 0
  }
}


