import Foundation
import UIKit
import SnapKit
import SafariServices
import WebKit

class EntryMainController : Controller {
  @IBOutlet weak var pageContainer       : UIView!
  @IBOutlet weak var toggleReadButton    : UIButton!
  @IBOutlet weak var toggleStarredButton : UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    pageContainer.addSubview(pageController.view)
    pageController.view.snp.makeConstraints { $0.edges.equalTo(pageContainer) }

    updateViews()
    markAsReadIfNeeded()
  }

  var entriesListController : EntriesListController!

  var entries : [Entry] {
    return entriesListController.repository.entries
  }

  lazy var pageController : UIPageViewController = {
    let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    controller.dataSource = self
    controller.delegate   = self
    addChild(controller)
    controller.didMove(toParent: self)
    return controller
  }()

  var currentEntryDetailsController : EntryDetailsController {
    return pageController.viewControllers![0] as! EntryDetailsController
  }

  var entry : Entry {
    return currentEntryDetailsController.entry
  }

  func updateViews() {
    if entry.isRead! {
      toggleReadButton.setImageForAllStates(UIImage.find("read"))
    } else {
      toggleReadButton.setImageForAllStates(UIImage.find("unread"))
    }

    if entry.isStarred! {
      toggleStarredButton.setImageForAllStates(UIImage.find("starred"))
    } else {
      toggleStarredButton.setImageForAllStates(UIImage.find("unstarred"))
    }

    entriesListController.updateViews()
  }

  func reloadHome() {
    HomeController.instance?.reloadDataSilently()
  }

  @IBAction func tapOnReadToggle() {
    EntryRepository(entry)
      .onChange { [weak self] in
        self?.updateViews()
        self?.reloadHome()
      }
      .toggleReadRequest().onError(showErrorIfNeeded).perform()
  }

  @IBAction func tapOnStarredToggle() {
    EntryRepository(entry)
      .onChange { [weak self] in
        self?.updateViews()
        self?.reloadHome()
      }
      .toggleStarredRequest().onError(showErrorIfNeeded).perform()
  }

  @IBAction func tapOnReader() {
    openSafari(entry.url?.url, readerMode: true)
  }

  @IBAction func tapOnOpen() {
    openSafari(entry.url?.url)
  }

  func openSafari(_ url: URL?, readerMode: Bool = false) {
    guard let url = url else { return }

    let config = SFSafariViewController.Configuration()
    config.entersReaderIfAvailable = readerMode
    let controller = SFSafariViewController(url: url, configuration: config)

    present(controller)
  }

  @IBAction func tapOnPrevious() {
    pageController.goToPreviousPage() {
      self.updateViews()
      self.markAsReadIfNeeded()
    }
  }

  @IBAction func tapOnNext() {
    pageController.goToNextPage() {
      self.updateViews()
      self.markAsReadIfNeeded()
    }
  }

  func markAsReadIfNeeded() {
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
    return entries.index(of: viewController.entry)!
  }

  func instantiateEntryDetailsController(_ index: Int) -> EntryDetailsController {
    let controller = instantiate(EntryDetailsController.self)
    controller.entry = entries[index]
    controller.webview.navigationDelegate = self
    return controller
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
