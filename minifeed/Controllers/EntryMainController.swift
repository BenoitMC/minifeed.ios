import Foundation
import UIKit
import SnapKit
import SafariServices
import WebKit
import RxSwift

class EntryMainController : Controller {
  var entriesListController : EntriesListController

  var entries : [Entry] {
    return entriesListController.entries
  }

  init(entriesListController: EntriesListController) {
    self.entriesListController = entriesListController

    super.init()

    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder: NSCoder) { fatalError() }

  private let toolbar             = UIToolbar()
  private let previousButton      = UIBarButtonItem(image: "previous")
  private let toggleReadButton    = UIBarButtonItem(image: "read")
  private let toggleStarredButton = UIBarButtonItem(image: "unstarred")
  private let readerButton        = UIBarButtonItem(image: "reader")
  private let safariButton        = UIBarButtonItem(image: "safari")
  private let nextButton          = UIBarButtonItem(image: "next")

  private func makeViews() {
    view.backgroundColor = .white
    view.addSubview(pageController.view)
    addChild(pageController)
    pageController.didMove(toParent: self)

    view.addSubview(toolbar)

    toolbar.items = [
      UIBarButtonItem.fixedSpace(-12),
      previousButton,
      UIBarButtonItem.flexibleSpace(),
      toggleReadButton,
      UIBarButtonItem.flexibleSpace(),
      toggleStarredButton,
      UIBarButtonItem.flexibleSpace(),
      readerButton,
      UIBarButtonItem.flexibleSpace(),
      safariButton,
      UIBarButtonItem.flexibleSpace(),
      nextButton,
      UIBarButtonItem.fixedSpace(-12)
    ]
  }

  private func makeConstraints() {
    pageController.view.snp.makeConstraints {
      $0.top.left.right.equalTo(view!.safeAreaLayoutGuide)
    }

    toolbar.snp.makeConstraints {
      $0.top.equalTo(pageController.view.snp.bottom)
      $0.bottom.left.right.equalTo(view!.safeAreaLayoutGuide)
    }
  }

  private func makeBindings() {
    previousButton.action      = #selector(tapOnPrevious)
    toggleReadButton.action    = #selector(tapOnReadToggle)
    toggleStarredButton.action = #selector(tapOnStarredToggle)
    readerButton.action        = #selector(tapOnReader)
    safariButton.action        = #selector(tapOnSafari)
    nextButton.action          = #selector(tapOnNext)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    updateViews()
    markAsReadIfNeeded()
  }

  private lazy var pageController : UIPageViewController = {
    let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    controller.view.backgroundColor = .white
    controller.dataSource = self
    controller.delegate   = self
    return controller
  }()

  var entry : Entry {
    return (pageController.viewControllers![0] as! EntryDetailsController).entry
  }

  func updateViews() {
    if entry.isRead! {
      toggleReadButton.image = UIImage.find("read")
    } else {
      toggleReadButton.image = UIImage.find("unread")
    }

    if entry.isStarred! {
      toggleStarredButton.image = UIImage.find("starred")
    } else {
      toggleStarredButton.image = UIImage.find("unstarred")
    }

    entriesListController.updateViews()
  }

  @objc
  private func tapOnReadToggle() {
    let repository = EntryRepository(entry)
    repository.toggleReadRequest().onError(showErrorIfNeeded).perform()
    repository.entryObservable.subscribe(onNext: entryUpdated).disposed(by: disposeBag)
  }

  @objc
  private func tapOnStarredToggle() {
    let repository = EntryRepository(entry)
    repository.toggleStarredRequest().onError(showErrorIfNeeded).perform()
    repository.entryObservable.subscribe(onNext: entryUpdated).disposed(by: disposeBag)
  }

  private func entryUpdated(_: Entry) {
    updateViews()
    NavRepository.instance.reload()
  }

  @objc
  private func tapOnReader() {
    openSafari(entry.url?.url, readerMode: true)
  }

  @objc
  private func tapOnSafari() {
    openSafari(entry.url?.url)
  }

  private func openSafari(_ url: URL?, readerMode: Bool = false) {
    guard let url = url else { return }

    let config = SFSafariViewController.Configuration()
    config.entersReaderIfAvailable = readerMode
    let controller = SFSafariViewController(url: url, configuration: config)

    present(controller)
  }

  @objc
  private func tapOnPrevious() {
    pageController.goToPreviousPage() {
      self.updateViews()
      self.markAsReadIfNeeded()
    }
  }

  @objc
  private func tapOnNext() {
    pageController.goToNextPage() {
      self.updateViews()
      self.markAsReadIfNeeded()
    }
  }

  private func markAsReadIfNeeded() {
    if !entry.isRead! { tapOnReadToggle() }
  }
}

extension EntryMainController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let currentIndex = getIndex(viewController)
    guard currentIndex > 0 else { return nil }

    return instantiateEntryDetailsController(currentIndex - 1)
  }

  func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let currentIndex = getIndex(viewController)
    guard currentIndex < (entries.count - 1) else { return nil }

    return instantiateEntryDetailsController(currentIndex + 1)
  }

  func getIndex(_ viewController: UIViewController) -> Int {
    let viewController = viewController as! EntryDetailsController
    return entries.firstIndex(of: viewController.entry)!
  }

  func instantiateEntryDetailsController(_ index: Int) -> EntryDetailsController {
    return EntryDetailsController(entry: entries[index], navigationDelegate: self)
  }

  func showEntryAtIndex(_ index: Int) {
    pageController.setViewControllers([instantiateEntryDetailsController(index)], direction: .forward, animated: false, completion: nil)
  }

  func pageViewController(_: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    updateViews()

    if finished && completed {
      markAsReadIfNeeded()
    }
  }
}

extension EntryMainController : WKNavigationDelegate {
  func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .other {
      decisionHandler(.allow)
    } else {
      openSafari(navigationAction.request.url)
      decisionHandler(.cancel)
    }
  }
}
